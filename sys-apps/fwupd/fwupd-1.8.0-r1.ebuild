# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit bash-completion-r1 linux-info meson python-single-r1 vala xdg

DESCRIPTION="Aims to make updating firmware on Linux automatic, safe and reliable"
HOMEPAGE="https://fwupd.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="amt archive bash-completion bluetooth cbor dell elogind fastboot flashrom gnutls gtk-doc gusb introspection logitech lzma +man minimal modemmanager nvme policykit spi +sqlite synaptics systemd test thunderbolt tpm uefi"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( elogind minimal systemd )
	dell? ( uefi )
	fastboot? ( gusb )
	logitech? ( gusb )
	minimal? ( !introspection )
	spi? ( lzma )
	synaptics? ( gnutls )
	uefi? ( gnutls )
"
RESTRICT="!test? ( test )"

BDEPEND="$(vala_depend)
	>=dev-util/meson-0.60.0
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	bash-completion? ( >=app-shells/bash-completion-2.0 )
	introspection? ( dev-libs/gobject-introspection )
	man? (
		app-text/docbook-sgml-utils
		sys-apps/help2man
	)
	test? (
		thunderbolt? ( dev-util/umockdev )
		net-libs/gnutls[tools]
	)
"
COMMON_DEPEND="${PYTHON_DEPS}
	>=app-arch/gcab-1.0
	app-arch/xz-utils
	>=dev-libs/glib-2.58:2
	dev-libs/json-glib
	dev-libs/libgudev:=
	>=dev-libs/libjcat-0.1.4[gpg,pkcs7]
	>=dev-libs/libxmlb-0.1.13:=[introspection?]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	')
	>=net-libs/libsoup-2.51.92:2.4[introspection?]
	net-misc/curl
	archive? ( app-arch/libarchive:= )
	cbor? ( dev-libs/libcbor )
	dell? ( >=sys-libs/libsmbios-2.4.0 )
	elogind? ( >=sys-auth/elogind-211 )
	flashrom? ( >=sys-apps/flashrom-1.2-r3 )
	gnutls? ( net-libs/gnutls )
	gusb? ( >=dev-libs/libgusb-0.3.5[introspection?] )
	logitech? ( dev-libs/protobuf-c:= )
	lzma? ( app-arch/xz-utils )
	modemmanager? ( net-misc/modemmanager[qmi] )
	policykit? ( >=sys-auth/polkit-0.114 )
	sqlite? ( dev-db/sqlite )
	systemd? ( >=sys-apps/systemd-211 )
	tpm? ( app-crypt/tpm2-tss:= )
	uefi? (
		sys-apps/fwupd-efi
		sys-boot/efibootmgr
		sys-fs/udisks
		sys-libs/efivar
	)
"
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/dbus
"

DEPEND="
	${COMMON_DEPEND}
	x11-libs/pango[introspection]
"

pkg_setup() {
	python-single-r1_pkg_setup
	vala_setup
	if use nvme ; then
		kernel_is -ge 4 4 || die "NVMe support requires kernel >= 4.4"
	fi
}

src_prepare() {
	default
	# c.f. https://github.com/fwupd/fwupd/issues/1414
	sed -e "/test('thunderbolt-self-test', e, env: test_env, timeout : 120)/d" \
		-i plugins/thunderbolt/meson.build || die

	sed -e '/platform-integrity/d' \
		-i plugins/meson.build || die #753521

	sed -e "/install_dir.*'doc'/s/fwupd/${PF}/" \
		-i data/builder/meson.build || die
}

src_configure() {
	local plugins=(
		-Dplugin_gpio="enabled"
		$(meson_feature amt plugin_amt)
		$(meson_feature dell plugin_dell)
		$(meson_feature fastboot plugin_fastboot)
		$(meson_feature flashrom plugin_flashrom)
		$(meson_feature gusb plugin_uf2)
		$(meson_feature logitech plugin_logitech_bulkcontroller)
		$(meson_feature modemmanager plugin_modem_manager)
		$(meson_feature nvme plugin_nvme)
		$(meson_use spi plugin_intel_spi)
		$(meson_feature synaptics plugin_synaptics_mst)
		$(meson_feature synaptics plugin_synaptics_rmi)
		$(meson_feature thunderbolt plugin_thunderbolt)
		$(meson_feature tpm plugin_tpm)
		$(meson_feature uefi plugin_uefi_capsule)
		$(meson_use uefi plugin_uefi_capsule_splash)
		$(meson_feature uefi plugin_uefi_pk)
	)
	if use ppc64 || use riscv ; then
		plugins+=( -Dplugin_msr="disabled" )
	fi

	local emesonargs=(
		--localstatedir "${EPREFIX}"/var
		-Dbuild="$(usex minimal standalone all)"
		-Dconsolekit="disabled"
		-Dcurl="enabled"
		-Ddocs="$(usex gtk-doc gtkdoc none)"
		-Defi_binary="false"
		-Dsupported_build="true"
		$(meson_feature archive libarchive)
		$(meson_use bash-completion bash_completion)
		$(meson_feature bluetooth bluez)
		$(meson_feature cbor)
		$(meson_feature elogind)
		$(meson_feature gnutls)
		$(meson_feature gusb)
		$(meson_feature lzma)
		$(meson_use man)
		$(meson_feature introspection)
		$(meson_feature policykit polkit)
		$(meson_feature sqlite)
		$(meson_feature systemd)
		$(meson_use test tests)

		${plugins[@]}
	)
	use uefi && emesonargs+=( -Defi_os_dir="gentoo" )
	export CACHE_DIRECTORY="${T}"
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use minimal ; then
		newinitd "${FILESDIR}"/${PN}-r2 ${PN}

		if ! use systemd ; then
			# Don't timeout when fwupd is running (#673140)
			sed '/^IdleTimeout=/s@=[[:digit:]]\+@=0@' \
				-i "${ED}"/etc/${PN}/daemon.conf || die
		fi
	fi
}