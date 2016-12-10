# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/mopidy/${PN}.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="Mopidy local library proxy extension for handling embedded album art."
HOMEPAGE="http://www.mopidy.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=media-sound/mopidy-2.0.0
	"
RDEPEND="${DEPEND}"
