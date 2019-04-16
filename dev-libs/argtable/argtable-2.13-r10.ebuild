# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="An ANSI C library for parsing GNU-style command-line options with minimal fuss"
HOMEPAGE="http://argtable.sourceforge.net/"

MY_P="${PN}$(ver_rs 1 '-')"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug examples static-libs"

PATCHES=(
	"${FILESDIR}/${P}-long-type.patch"
	"${FILESDIR}/${P}-ctype-warnings.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${D}"/usr/share/doc/${PF}/

	dodoc AUTHORS ChangeLog NEWS README

	if use doc ; then
		cd "${S}/doc"
		dodoc *.pdf *.ps
		docinto html
		dodoc *.html *.gif
	fi

	if use examples ; then
		cd "${S}/example"
		docinto examples
		dodoc Makefile *.[ch] README.txt
	fi

	find "${ED}" -name "*.la" -delete || die "failed to delete .la files"
}
