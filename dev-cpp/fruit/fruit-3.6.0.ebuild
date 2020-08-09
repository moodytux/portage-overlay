# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS="cmake"
CMAKE_BUILD_TYPE="Release"

inherit cmake-multilib

DESCRIPTION="Fruit, a dependency injection framework for C++ by Google."
HOMEPAGE="https://github.com/google/fruit"
SRC_URI="https://github.com/google/fruit/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND=""
BDEPEND=""
