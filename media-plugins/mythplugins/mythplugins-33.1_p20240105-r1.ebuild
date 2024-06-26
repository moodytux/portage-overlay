# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Grab only the major version number.
MAJOR_PV=${PV%%.*}

PYTHON_COMPAT=( python3_11 )

inherit python-single-r1 readme.gentoo-r1

DESCRIPTION="Official MythTV plugins"
HOMEPAGE="https://www.mythtv.org https://github.com/MythTV/mythtv"
# mythtv and mythplugins are separate builds in the same github MythTV/mythtv repository
if [[ $(ver_cut 3) == "p" ]] ; then
	MY_COMMIT="6b442547f2746b01f51a051438b4d02db9441b36"
	SRC_URI="https://github.com/MythTV/mythtv/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/mythtv-${MY_COMMIT}/mythplugins"
else
	SRC_URI="https://github.com/MythTV/mythtv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/mythtv-${PV}/mythplugins"
fi
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

MYTHPLUGINS="mytharchive mythbrowser mythgame \
mythmusic mythnetvision mythnews mythweather mythzmserver mythzoneminder"
IUSE="${MYTHPLUGINS} alsa cdda cdr exif +hls ieee1394 libass +opengl raw +theora +vorbis +xml xvid"

# Mythnetvision temporarily disabled by upstream - should be fixed soon.
REQUIRED_USE="
	!mythnetvision
	mytharchive? ( ${PYTHON_REQUIRED_USE} )
	mythnetvision? ( ${PYTHON_REQUIRED_USE} )
	mythmusic? ( vorbis )
	mythnews? ( mythbrowser )
"
RDEPEND="
	dev-libs/glib:2
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtsql:5
	media-libs/freetype:2
	media-libs/libpng:=
	virtual/libudev:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXv
	x11-libs/libXxf86vm
	alsa? ( media-libs/alsa-lib )
	hls? (
		media-libs/faac
		media-libs/libvpx:=
		media-libs/x264:=
		media-sound/lame
	)
	ieee1394? (
		media-libs/libiec61883
		sys-libs/libavc1394
		sys-libs/libraw1394
	)
	libass? ( media-libs/libass:= )
	=media-tv/mythtv-${MAJOR_PV}*[alsa?,cdda?,cdr?,exif?,ieee1394?,libass?,opengl?,raw?,xml?,xvid]
	mytharchive? (
		${PYTHON_DEPS}
		app-cdr/dvd+rw-tools
		dev-python/pillow
		dev-python/mysqlclient
		=media-tv/mythtv-${MAJOR_PV}*[python]
		media-video/dvdauthor
		media-video/mjpegtools[png]
		media-video/ffmpeg
		app-cdr/cdrtools
	)
	mythbrowser? ( dev-qt/qtwebkit:5 )
	mythgame? (
		sys-libs/zlib[minizip]
		dev-perl/XML-Twig
	)
	mythmusic? (
		dev-qt/qtwebkit:5
		media-libs/flac
		media-libs/libogg
		media-libs/libvorbis
		media-libs/taglib
		media-sound/lame
		opengl? ( virtual/opengl )
		cdda? (
			media-sound/cdparanoia
			dev-libs/libcdio:=
			cdr? ( app-cdr/cdrtools )
		)
	)
	mythnetvision? (
		${PYTHON_DEPS}
		dev-python/lxml
		dev-python/oauth2
		dev-python/pycurl
		dev-python/urllib3
		=media-tv/mythtv-${MAJOR_PV}*[python]
	)
	mythweather? (
		dev-perl/Date-Manip
		dev-perl/XML-Simple
		dev-perl/XML-XPath
		dev-perl/DateTime
		dev-perl/Image-Size
		dev-perl/DateTime-Format-ISO8601
		dev-perl/SOAP-Lite
		dev-perl/JSON
		=media-tv/mythtv-${MAJOR_PV}*[perl]
	)
	mythzmserver? ( dev-db/mysql-connector-c:= )
	theora? ( media-libs/libtheora )
	xml? ( dev-libs/libxml2:= )
	xvid? ( media-libs/xvid )
"
DEPEND=${RDEPEND}

PATCHES=(
	"${FILESDIR}/${PN}-Support_ripping_subsets_of_tracks.patch"
)

DOC_CONTENTS="
Mythgallery code moved to mythtv and is no longer a plugin in version 31.0.
As of 3/23/2020, MythNetVision is disabled, work in progress.

No plugins are installed by default. Enable plugins individually with USE flags:
mytharchive mythbrowser mythgame mythmusic mythnetvision mythnews mythweather mythzmserver mythzoneminder

To use mythmusic, you will need to unmask dev-qt/qtwebkit, and add the following to
/etc/portage/profile/package.use.mask to allow mythmusic to proceed:

media-plugins/mythplugins -mythmusic
"

src_configure() {
	econf \
		--python=${EPYTHON} \
		--extra-ldflags="${LDFLAGS}" \
		$(use_enable cdda cdio) \
		$(use_enable exif) \
		$(use_enable exif new-exif) \
		$(use_enable opengl) \
		$(use_enable raw dcraw) \
		$(use_enable mytharchive) \
		$(use_enable mythbrowser) \
		$(use_enable mythgame) \
		$(use_enable mythmusic) \
		$(use_enable mythnetvision) \
		$(use_enable mythnews) \
		$(use_enable mythweather) \
		$(use_enable mythzmserver) \
		$(use_enable mythzoneminder)
}

src_install() {
	emake STRIP="true" INSTALL_ROOT="${D}" install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
