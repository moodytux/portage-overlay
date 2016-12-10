# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/tkem/${PN}.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="RFC 3986 compliant, Unicode-aware, scheme-agnostic replacement for urlparse"
HOMEPAGE="https://github.com/tkem/uritools"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
