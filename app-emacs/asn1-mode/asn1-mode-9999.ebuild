# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator elisp

DESCRIPTION="ASN.1/GDMO mode for GNU Emacs"
HOMEPAGE="https://github.com/kawabata/asn1-mode"

if [[ ${PV} == "9999" ]]; then
	MY_PV=${PV}
	EGIT_REPO_URI="git@github.com:kawabata/asn1-mode.git"
	inherit git-r3
	MY_PV=${PV}
else
	eerror "This ebuild does not currently work except as a live ebuild"
	eerror "as upstream does not have any tagged releases."
	die
	# If it did have tags, then it would go something like this:
	# MY_PV=$(get_version_component_range 1-3 ${PV})
	# P=${PN}-${MY_PV}
	# S=${WORKDIR}/${P}
	# SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"
fi

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RDEPEND="app-emacs/s"

SITEFILE="50${PN}-gentoo.el"
