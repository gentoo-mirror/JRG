# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Peter Gutmann's ASN.1 dump utility"
HOMEPAGE="https://www.cs.auckland.ac.nz/~pgut001/"
SRC_URI="https://dev.gentoo.org/~john_r_graham/distfiles/${P}.tar.xz"

# This isn't quite right. Fix this.
LICENSE="WTFPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"
S=${WORKDIR}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/dumpasn1-20170218-config-file-path.patch
	)
	default
}

src_compile() {
	gcc ${CFLAGS} dumpasn1.c -o dumpasn1
}

src_install() {
	dobin dumpasn1

	insinto /usr/share/${PN}
	doins ${PN}.cfg
}
