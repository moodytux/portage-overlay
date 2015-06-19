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
IUSE=""

DEPEND="dev-python/gst-python
	media-plugins/gst-plugins-meta:0.10"
RDEPEND="${DEPEND}"

python_install_all() {
    newinitd "${FILESDIR}/init.d" mopidy
    newconfd "${FILESDIR}/conf.d" mopidy
    distutils-r1_python_install_all
}

pkg_postinst() {
    elog "Please ensure you modify /etc/conf.d/mopidy to point to your local"
    elog "music store before starting the server."
}
