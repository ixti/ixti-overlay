# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="wal2json_${PV//\./_}"

DESCRIPTION="JSON output plugin for changeset extraction"
HOMEPAGE="https://github.com/eulerto/wal2json"
SRC_URI="https://github.com/eulerto/wal2json/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/wal2json-${MY_P}"

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"
BDEPEND=""
