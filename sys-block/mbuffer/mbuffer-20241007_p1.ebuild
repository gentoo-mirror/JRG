# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature

DESCRIPTION="M(easuring)buffer is a replacement for buffer with additional functionality (+ JRG race condition patch)"
HOMEPAGE="https://www.maier-komor.de/mbuffer.html"

if [[ $(ver_cut 2) == p ]] ; then
	MY_PV=$(ver_cut 1)
	PATCH_LEVEL=$(ver_cut 3)
else
	MY_PV=${PV}
fi
MY_P="${PN}-${MY_PV}"
SRC_URI="https://www.maier-komor.de/software/mbuffer/${MY_P}.tgz"
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

PATCHES=(
	"${FILESDIR}/${PN}-20180410-sysconfdir.patch"
	"${FILESDIR}/${PN}-20200929-find-OBJDUMP.patch"
	"${FILESDIR}/${PN}-20231216-autoconf-warning.patch"
)

if [[ "$PATCH_LEVEL" == "1" ]] ; then
	   PATCHES+=( "${FILESDIR}/mbuffer-20100526-race-condition.patch" )
fi

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

pkg_postinst() {
	optfeature "autoloader support" app-arch/mt-st
}
