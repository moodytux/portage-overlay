# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="GUI for monero - the secure, private, untraceable cryptocurrency"
HOMEPAGE="https://www.getmonero.org https://github.com/monero-project/monero-gui"
SRC_URI=""
EGIT_REPO_URI="https://github.com/monero-project/monero-gui.git"
EGIT_COMMIT="v${PV}"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=""

DEPEND="
	net-p2p/monero
	dev-libs/hidapi
	dev-qt/qtcore:5
	dev-qt/qtxmlpatterns:5[qml]
	dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtgraphicaleffects:5"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
)

src_configure() {
	local mycmakeargs=(
		# Monero's liblmdb conflicts with the system liblmdb :(
		-DBUILD_SHARED_LIBS=OFF
		-DMANUAL_SUBMODULES=ON
		-DMONERO_PARALLEL_LINK_JOBS=1
	)

	cmake_src_configure
}

src_compile() {
	cmake_build
}

src_install() {
	dobin "${BUILD_DIR}/bin/monero-gen-trusted-multisig"
	dobin "${BUILD_DIR}/bin/monero-wallet-gui"
	dobin "${BUILD_DIR}/bin/monero-gen-ssl-cert"
}
