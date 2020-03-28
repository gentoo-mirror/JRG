# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..8} )

inherit git-r3 python-single-r1 desktop

DESCRIPTION="A Fully Featured Markdown Editor"
HOMEPAGE="https://remarkableapp.github.io/index.html"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtksourceview:3.0
	net-libs/webkit-gtk
	dev-python/beautifulsoup
"

# JRG: Special version numbers to access specific branches.
case "${PV}" in
	# Head of master branch. This is a Gentoo convention.
	9999)
		EGIT_REPO_URI="https://github.com/jamiemcg/Remarkable.git"
		;;
	# Normal upstream tarball releases.
	*)
		SRC_URI="https://github.com/jamiemcg/Remarkable/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		;;
esac

src_unpack() {
	case "${PV}" in
		9999|9998)
			git-r3_fetch ${EGIT_REPO_URI} ${REFS} ${TAG}
			git-r3_checkout ${EGIT_REPO_URI} "${WORKDIR}/${P}" ${TAG}
			;;
		*)
			default
			;;
	esac
}

src_prepare() {
	default
	cd ${S}
	mkdir Temp
	cp ${FILESDIR}/remarkable Temp
	sed -i "s|PYTHON_SITEDIR|$(python_get_sitedir)|" Temp/remarkable
}

src_install() {
	python_moduleinto remarkable
	python_domodule markdown pdfkit remarkable remarkable_lib bin
	dodir /usr/share/${PN}
	cp -R ${S}/data/* ${D}/usr/share/${PN}/
	exeinto /usr/bin
	doexe ${S}/Temp/remarkable
	chmod +x ${D}/$(python_get_sitedir)/remarkable/bin/remarkable

	doicon data/ui/remarkable.png
	domenu remarkable.desktop
}
