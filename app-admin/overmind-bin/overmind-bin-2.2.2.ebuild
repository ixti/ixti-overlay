# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Process manager for Procfile-based applications and tmux."
HOMEPAGE="https://github.com/DarthSim/overmind"
SRC_URI="https://github.com/DarthSim/overmind/releases/download/v${PV}/overmind-v${PV}-linux-amd64.gz -> ${P}.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	app-misc/tmux
	!app-admin/overmind"

S="${WORKDIR}"

src_install() {
	newbin "${P}" overmind
}
