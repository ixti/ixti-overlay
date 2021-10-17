# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Transparent encryption of files within a Git repository"
HOMEPAGE="https://github.com/elasticdog/transcrypt"
SRC_URI="https://github.com/elasticdog/transcrypt/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}
	>=app-shells/bash-3.0
	dev-libs/openssl
	dev-vcs/git
	sys-apps/util-linux
	"

src_install() {
	dobin transcrypt
	doman man/transcrypt.1
}
