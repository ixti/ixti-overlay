# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Papirus is a free and open source SVG icon theme for Linux"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme"
SRC_URI="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

IUSE="pantheon"

src_compile() { :; }

src_install() {
	insinto /usr/share/icons
	doins -r Papirus{,-Dark,-Light}
	use pantheon && doins -r ePapirus{,-Dark}
}
