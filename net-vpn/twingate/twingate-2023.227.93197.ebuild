# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 systemd unpacker

DESCRIPTION="High performance, zero trust network"
HOMEPAGE="https://docs.twingate.com/docs/linux"
SRC_URI="https://binaries.twingate.com/client/linux/ARCH/x86_64/${PV}/twingate-amd64.pkg.tar.zst -> ${P}.tar.zst"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-fs/cryptsetup sys-apps/dbus dev-libs/libnl"
RDEPEND="${DEPEND}"
BDEPEND="app-arch/zstd"

S="${WORKDIR}"

src_unpack() {
	unpacker

	# touch ${S}/etc/twingate/user_intention_file
	# touch ${S}/etc/twingate/purge_file

	# rm -rf ${S}/run
	# rm -rf ${S}/var
}

src_install() {
	dobashcomp ${S}/usr/share/bash-completion/completions/twingate

	dosbin ${S}/usr/bin/twingated
	dobin ${S}/usr/bin/twingate
	dobin ${S}/usr/bin/twingate-notifier

	insinto /etc
	doins -r ${S}/etc/twingate

	# doinitd ${FILESDIR}/twingate

	systemd_dounit "${S}/usr/lib/systemd/system/twingate.service"
	systemd_dounit "${S}/usr/lib/systemd/user/twingate-desktop-notifier.service"

	# mkdir -p ${D}/usr/sbin/ || die "Install failed!"
	# mv ${S}/usr/bin/twingated ${D}/usr/sbin/twingated || die "Install failed!"
	# cp -R ${S}/* "${D}/" || die "Install failed!"
}
