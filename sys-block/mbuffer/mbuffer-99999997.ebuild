# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature git-r3

DESCRIPTION="M(easuring)buffer is a replacement for buffer with additional functionality (+ JRG race condition patch)"
HOMEPAGE="https://www.maier-komor.de/mbuffer.html"

# JRG: Special version numbers to access specific branches or patch sets.
case "${PV}" in
	# Head of master branch. This is a Gentoo convention.
	99999999)
		MY_PV="${PV}"
		MY_P="${PN}-${MY_PV}"
		EGIT_REPO_URI="file:///home/jgraham/Projects/Gentoo/mbuffer"
		;;
	# My local research branch.
	99999997)
		MY_PV="${PV}"
		MY_P="${PN}-${MY_PV}"
		EGIT_REPO_URI="file:///home/jgraham/Projects/Gentoo/mbuffer"
		REFS="refs/heads/semaphores"
		;;
	# Normal upstream tarball releases.
	*)
		MY_PV="{$PV}"
		MY_P="${PN}-${MY_PV}"
		SRC_URI="https://www.maier-komor.de/software/mbuffer/${MY_P}.tgz"
		KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
		;;
esac

S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="debug ssl test"
REQUIRED_USE="test? ( ssl )"
RESTRICT="!test? ( test )"

RDEPEND="
	ssl? (
		dev-libs/openssl
	)
"
DEPEND="${RDEPEND}"

src_unpack() {
	case "${MY_PV}" in
		99999999|99999998|99999997)
			git-r3_fetch ${EGIT_REPO_URI} ${REFS} ${TAG}
			git-r3_checkout ${EGIT_REPO_URI} "${WORKDIR}/${MY_P}" ${TAG}
			;;
		*)
			default
			;;
	esac
}

src_prepare() {
	default

	ln -s "${DISTDIR}"/${MY_P}.tgz test.tar # bug #258881

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ssl md5)
		$(use_enable debug)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Enforce MAKEOPTS=-j1 because src_test() spawns multiple listener
	# using same port and src_install may have problems (with /etc folder)
	local -x MAKEOPTS=-j1

	default
}

pkg_prerm() {
	einfo "Hello from pkg_prerm()."
}

pkg_postinst() {
	optfeature "autoloader support" app-arch/mt-st
}
