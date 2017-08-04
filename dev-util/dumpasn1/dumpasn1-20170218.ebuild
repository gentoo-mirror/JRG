# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Peter Gutmann's ASN.1 dump utility"
HOMEPAGE="https://www.cs.auckland.ac.nz/~pgut001/"
SRC_URI="dumpasn1-${PV}.tar.bz"
RESTRICT="fetch"

# This isn't quite right. Fix this.
LICENSE="WTFPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"
RDEPEND="${DEPEND}"
S=${WORKDIR}

pkg_nofetch() {
	einfo "Because Peter Gutmann doesn't have proper release tarballs, you need to"
	einfo "fetch the following source files from his website:"
	einfo "    https://www.cs.auckland.ac.nz/~pgut001/dumpasn1.c"
	einfo "    https://www.cs.auckland.ac.nz/~pgut001/dumpasn1.cfg"
	einfo "and tar them up into a tarball named:"
	einfo "    dumpasn1-yyyymmdd.tar.bz"
	einfo "Get the date from a #define macro in the source code named UPDATE_STRING."
	einfo ""
	einfo "An example tar command is as follows:"
	einfo "    tar -cjvf dumpasn1-${PV}.tar.bz dumpasn1.c dumpasn1.cfg"
	einfo ""
	einfo "Place the resultant tarball in '${DISTDIR}'."
}

src_prepare() {
	epatch "${FILESDIR}/${P}-config-file-path.patch"
	default
}

src_compile() {
	gcc dumpasn1.c -o dumpasn1
}

src_install() {
	dobin dumpasn1

	insinto /usr/share/${PN}
	doins ${PN}.cfg
}
