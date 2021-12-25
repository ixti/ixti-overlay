# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Opensource, compact, and material-designed round edge cursor set"
HOMEPAGE="https://github.com/ful1e5/Bibata_Cursor"
SRC_URI="https://github.com/ful1e5/Bibata_Cursor/releases/download/v${PV}/Bibata-Modern.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

src_prepare() {
	eapply_user
	rm -f */*.theme
}

src_install() {
	insinto /usr/share/cursors/xorg-x11
	doins -r Bibata-Modern-{Amber,Classic,Ice}
}
