# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} = *9999 ]]; then
	EGIT_BRANCH="qtwebkit-5.212"
	EGIT_REPO_URI="https://github.com/qtwebkit/qtwebkit.git"
	inherit git-r3
else
	MY_P="${PN}-${PV/_pre20200309/-alpha4}" # present as upgrade over previous snapshot
	SRC_URI="https://github.com/annulen/webkit/releases/download/${MY_P}/${MY_P}.tar.xz"
	KEYWORDS="amd64 arm arm64 ppc64 x86"
	S="${WORKDIR}/${MY_P}"
fi
PYTHON_COMPAT=( python3_{10..11} )
USE_RUBY="ruby31 ruby32"
inherit check-reqs cmake flag-o-matic python-any-r1 qmake-utils ruby-single toolchain-funcs

DESCRIPTION="WebKit rendering library for the Qt5 framework (deprecated)"
HOMEPAGE="https://www.qt.io/"

LICENSE="BSD LGPL-2+"
SLOT="5/5.212"
IUSE="geolocation gles2-only +gstreamer +hyphen +jit multimedia nsplugin opengl orientation +printsupport qml webp X"

REQUIRED_USE="
	nsplugin? ( X )
	qml? ( opengl )
	?? ( gstreamer multimedia )
"

# Dependencies found at Source/cmake/OptionsQt.cmake
QT_MIN_VER="5.12.3:5"
BDEPEND="
	${PYTHON_DEPS}
	${RUBY_DEPS}
	dev-lang/perl
	dev-util/gperf
	>=sys-devel/bison-2.4.3
	sys-devel/flex
	virtual/pkgconfig
"
DEPEND="
	dev-db/sqlite:3
	dev-libs/icu:=
	dev-libs/libxml2
	dev-libs/libxslt
	>=dev-qt/qtcore-${QT_MIN_VER}
	>=dev-qt/qtgui-${QT_MIN_VER}
	>=dev-qt/qtnetwork-${QT_MIN_VER}
	>=dev-qt/qtwidgets-${QT_MIN_VER}=
	media-libs/libpng:0=
	media-libs/woff2
	virtual/jpeg:0
	geolocation? ( >=dev-qt/qtpositioning-${QT_MIN_VER} )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	hyphen? ( dev-libs/hyphen )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_MIN_VER}[widgets] )
	opengl? (
		>=dev-qt/qtgui-${QT_MIN_VER}[gles2-only=]
		>=dev-qt/qtopengl-${QT_MIN_VER}[gles2-only=]
	)
	orientation? ( >=dev-qt/qtsensors-${QT_MIN_VER} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_MIN_VER} )
	qml? (
		>=dev-qt/qtdeclarative-${QT_MIN_VER}
		>=dev-qt/qtwebchannel-${QT_MIN_VER}[qml]
	)
	webp? ( media-libs/libwebp:= )
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXrender
	)
"
RDEPEND="${DEPEND}"

CHECKREQS_DISK_BUILD="16G" # bug 417307

PATCHES=(
	"${FILESDIR}/${P}-bison-3.7.patch" # bug 736499
	"${FILESDIR}/${P}-icu-68.patch" # bug 753260
	"${FILESDIR}/${P}-python-3.9.patch" # bug 766303
	"${FILESDIR}/${P}-glib-2.68.patch" # bug 777759
	"${FILESDIR}/${P}-position.patch"
	# From https://github.com/WebKit/WebKit/commit/c7d19a492d97f9282a546831beb918e03315f6ef
	# Ruby 3.2 removes Object#=~ completely
	"${FILESDIR}/${P}-webkit-offlineasm-warnings-ruby27.patch"
	# GCC 13
	"${FILESDIR}/${P}-cstdint.patch"
	"${FILESDIR}/${P}-libxml-2.12.patch"
	"${FILESDIR}/${P}-build-gcc14.patch"
	"${FILESDIR}/${P}-icu-75.patch"
	"${FILESDIR}/${P}-icu-76.1.patch"
)

_check_reqs() {
	if [[ ${MERGE_TYPE} != binary ]] && is-flagq "-g*" && ! is-flagq "-g*0"; then
		einfo "Checking for sufficient disk space to build ${PN} with debugging flags"
		check-reqs_$1
	fi
}

pkg_pretend() {
	_check_reqs pkg_pretend
}

pkg_setup() {
	_check_reqs pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Respect CC, otherwise fails on prefix, bug #395875
	tc-export CC

	# Multiple rendering bugs on youtube, github, etc without this, bug #547224
	append-flags $(test-flags -fno-strict-aliasing)

	local mycmakeargs=(
		-DPORT=Qt
		-DENABLE_API_TESTS=OFF
		-DENABLE_TOOLS=OFF
		-DENABLE_GEOLOCATION=$(usex geolocation)
		-DUSE_GSTREAMER=$(usex gstreamer)
		-DUSE_LIBHYPHEN=$(usex hyphen)
		-DENABLE_JIT=$(usex jit)
		-DUSE_QT_MULTIMEDIA=$(usex multimedia)
		-DENABLE_NETSCAPE_PLUGIN_API=$(usex nsplugin)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_PRINT_SUPPORT=$(usex printsupport)
		-DENABLE_DEVICE_ORIENTATION=$(usex orientation)
		-DENABLE_WEBKIT2=$(usex qml)
		$(cmake_use_find_package webp WebP)
		-DENABLE_X11_TARGET=$(usex X)
	)

	if has_version "virtual/rubygems[ruby_targets_ruby32]"; then
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby32) )
	else
		mycmakeargs+=( -DRUBY_EXECUTABLE=$(type -P ruby31) )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# bug 572056
	if [[ ! -f ${ED}$(qt5_get_libdir)/libQt5WebKit.so ]]; then
		eerror "${CATEGORY}/${PF} could not build due to a broken ruby environment."
		die 'Check "eselect ruby" and ensure you have a working ruby in your $PATH'
	fi
}
