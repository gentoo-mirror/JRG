# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Open Source ASN.1 Compiler"
HOMEPAGE="http://asn1c.sourceforge.net/"
SRC_URI="http://lionet.info/soft/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install(){
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc BUGS FAQ TODO || die "dodoc failed"
}
