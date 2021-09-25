# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bitwarden command-line interface"
HOMEPAGE="https://bitwarden.com/"
SRC_URI="https://github.com/bitwarden/cli/releases/download/v${PV}/bw-linux-${PV}.zip -> ${P}.zip"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dobin bw
}
