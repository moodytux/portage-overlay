# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/mopidy/${PN}.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="Plugin to Mopidy which provides a searchable SQLite database for more comprehensive searches on local media."
HOMEPAGE="http://www.mopidy.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/python:2.7[sqlite]
        >=media-sound/mopidy-2.0.0
        >=dev-python/uritools-1.0.2
	"
RDEPEND="${DEPEND}"
