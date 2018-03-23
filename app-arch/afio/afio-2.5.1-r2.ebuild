# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs git-r3

DESCRIPTION="Afio creates cpio-format archives."
HOMEPAGE="http://members.chello.nl/k.holtman/afio.html https://github.com/kholtman/afio"

LICENSE="Artistic LGPL-2"
SLOT="0"

# JRG: Special version numbers to access specific branches.
case "${PV}" in
	# Head of master branch. This is a Gentoo convention.
	9999)
		EGIT_REPO_URI="git@github.com:kholtman/afio.git"
		PATCHES=( "${FILESDIR}"/${PN}-9999-fix-build-system.patch )
		;;
	# Local research branch.
	9998)
		EGIT_REPO_URI="file:///home/johngrah/Projects/Gentoo/afio/"
		REFS="refs/heads/control-file-warning-fix"
		PATCHES=( "${FILESDIR}"/${PN}-9999-fix-build-system.patch )
		;;
	# Tagged but not released upstream version.
	2.5.1.2)
		EGIT_REPO_URI="git@github.com:kholtman/afio.git"
		TAG="v2.5.1-2"
		REFS="refs/tags/${TAG}"
		PATCHES=( "${FILESDIR}"/${P}-fix-build-system.patch
				  "${FILESDIR}"/${P}-compile-errors.patch
				)
		;;
	# Normal upstream tarball releases.
	*)
		SRC_URI="http://members.chello.nl/k.holtman/${P}.tgz"
		KEYWORDS="alpha amd64 ~hppa ppc sparc x86"
		PATCHES=( "${FILESDIR}"/${PN}-2.5.1-fix-build-system.patch
				  "${FILESDIR}"/${PN}-2.5.1-control-file-warning-fix.patch
				)
		;;
esac

src_unpack() {
	case "${PV}" in
		9999|9998|2.5.1.2)
			git-r3_fetch ${EGIT_REPO_URI} ${REFS} ${TAG}
			git-r3_checkout ${EGIT_REPO_URI} "${WORKDIR}/${P}" ${TAG}
			;;
		*)
			default_src_unpack
			;;
	esac
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc ANNOUNCE-* HISTORY README SCRIPTS

	local i
	for i in {1..4}; do
		docinto "script${i}"
		dodoc -r "script${i}"/.
	done
}
