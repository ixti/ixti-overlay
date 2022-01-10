# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit bash-completion-r1 python-any-r1

DESCRIPTION="A dotfile manager for the config files in your home folder"
HOMEPAGE="https://github.com/TheLocehiliosan/yadm/"
SRC_URI="https://github.com/TheLocehiliosan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/gnupg
	dev-vcs/git
"

BDEPEND="
	test? (
		${RDEPEND}
		${PYTHON_DEPS}
		dev-python/pytest
		dev-tcltk/expect
	)
"

python_check_deps() {
	has_version -b "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_compile() {
	emake "${PN}.md"
}

src_test() {
	# test_encryption: needs write access to /tmp
	# test_alt, test_compat_jinja, test_unit_template_j2: needs envtpl
	# test_syntax: needs =dev-util/yamllint-1.17.0 (not packaged)
	# test_compat_alt: known broken, tests deprecated features
	# test_compat_jinja: needs envtpl
	rm -v test/test_encryption.py || die
	rm -v test/test_alt.py || die
	rm -v test/test_compat_jinja.py || die
	rm -v test/test_unit_template_j2.py || die
	rm -v test/test_syntax.py || die
	rm -v test/test_compat_alt.py || die

	pytest || die "Testsuite failed under ${EPYTHON}"
}

src_install() {
	einstalldocs

	dobin "${PN}"
	doman "${PN}.1"

	dobashcomp completion/bash/yadm

	insinto /usr/share/zsh/site-functions
	doins completion/zsh/_${PN}

	insinto /usr/share/fish/completions
	doins completion/fish/${PN}.fish
}
