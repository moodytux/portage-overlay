# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python3_{8..12})
DISTUTILS_USE_PEP517=setuptools
inherit git-r3 distutils-r1

DESCRIPTION="CLI for Microsoft IntelliMouse"
HOMEPAGE="https://github.com/madsl/Pro-IntelliMouse-Control-Panel/"
EGIT_REPO_URI="https://github.com/madsl/Pro-IntelliMouse-Control-Panel/"
LICENSE="GPL-3"
RESTRICT="test"

KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""
RDEPEND=">=dev-python/hidapi-0.9.0[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"



