# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1 git-r3

EGIT_REPO_URI="git://github.com/${PN}/${PN}.git"
EGIT_COMMIT="v${PV}"

DESCRIPTION="Music server with MPD and Spotify support, with frontends for various platforms inc. Android and iOS."
HOMEPAGE="http://www.mopidy.com/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="shout"

DEPEND="dev-python/gst-python:1.0
    media-plugins/gst-plugins-meta:1.0
    >=www-servers/tornado-2.3
    >=dev-python/pykka-1.1
    shout? (
        net-misc/icecast
        media-plugins/gst-plugins-shout2:1.0
        media-plugins/gst-plugins-lame:1.0
	)"
RDEPEND="${DEPEND}"

python_install_all() {
    newinitd "${FILESDIR}/init.d" mopidy
    insinto /etc/mopidy
    newins "${FILESDIR}/mopidy-2.conf" "mopidy.conf"
    distutils-r1_python_install_all
}

pkg_postinst() {
    elog "Be sure to enable the MPD server by modifying the [mpd] section in"
    elog "/etc/mopidy/mopidy.conf."
    elog
    elog "To enable local playback, edit the [local] config entries and point media_dir to"
    elog "your local music store. Then run:"
    elog
    elog "    /etc/init.d/mopidy scan"
    elog
    elog "before starting the server."

    if use shout; then
        elog
        elog "You have compiled in support for icecast which provides support to stream"
        elog "to other devices on your network. Make sure your icecast server is running"
        elog "to use it with mopidy, and update the [output] section in the config."
    fi
}
