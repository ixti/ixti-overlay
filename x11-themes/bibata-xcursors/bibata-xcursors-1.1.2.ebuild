# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Material Based Cursors."
HOMEPAGE="https://github.com/ful1e5/Bibata_Cursor"
SRC_URI="
	modern? ( https://github.com/ful1e5/Bibata_Cursor/releases/download/v${PV}/Bibata-Modern.tar.gz -> ${P}-modern.tar.gz )
	original? ( https://github.com/ful1e5/Bibata_Cursor/releases/download/v${PV}/Bibata-Original.tar.gz -> ${P}-original.tar.gz )
	"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+modern original"
REQUIRED_USE="|| ( modern original )"

S="${WORKDIR}"

src_prepare() {
	eapply_user
	rm -f */*.theme
}

src_install() {
	insinto /usr/share/cursors/xorg-x11

	use modern && doins -r Bibata-Modern-{Amber,Classic,Ice}
	use original && doins -r Bibata-Original-{Amber,Classic,Ice}
}
