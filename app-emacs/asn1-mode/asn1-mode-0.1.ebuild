# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp git-r3

DESCRIPTION="ASN.1/GDMO mode for GNU Emacs"
HOMEPAGE="https://github.com/kawabata/asn1-mode"

EGIT_REPO_URI="git@github.com:kawabata/asn1-mode.git"

if [[ ${PV} == "9999" ]]; then
	KEYWORDS=""
else
	# Framework to support multiple created versions in the absence of proper
	# upstream tagging.
	case "${PV}" in
		0.1)
			EGIT_COMMIT="c2447175"
			KEYWORDS="~amd64"
			;;
		*)
			eerror "No commit ID recorded for version ${PV}. Currently working on getting"
			eerror "upstream to properly tag their releases."
			die
			;;
	esac
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RDEPEND="app-emacs/s"

SITEFILE="50${PN}-gentoo.el"
