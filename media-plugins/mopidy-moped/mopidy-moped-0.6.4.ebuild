# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/martijnboland/moped.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="Web Client for Mopidy, built with AngularJS"
HOMEPAGE="https://github.com/martijnboland/moped"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=media-sound/mopidy-2.0.0[images]
	"
RDEPEND="${DEPEND}"
