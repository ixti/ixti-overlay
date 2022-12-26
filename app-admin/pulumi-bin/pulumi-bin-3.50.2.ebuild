# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Universal Infrastructure as Code"
HOMEPAGE="https://www.pulumi.com/"
SRC_URI="https://github.com/pulumi/pulumi/releases/download/v${PV}/pulumi-v${PV}-linux-x64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/pulumi"

src_install() {
	dobin pulumi*
}
