# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit user perl-app

DESCRIPTION="The MDD server side element to MythDroid"
HOMEPAGE="http://code.google.com/p/mythdroid/"
SRC_URI="http://mythdroid.googlecode.com/files/mdd-0.6.3.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="${RDEPEND}
		>=virtual/perl-Module-Build-0.34.0201"
RDEPEND=">=dev-lang/perl-5.12.4-r1[ithreads]
		 >=dev-perl/Image-Imlib2-2.30.0
		 >=dev-perl/HTTP-Daemon-6.10.0
		 >=virtual/perl-Time-HiRes-1.972.200
		 >=media-tv/mythtv-0.26
	"

src_unpack() {
	unpack ${A}
	cd mdd
	S=`pwd`
}

src_prepare() {
	epatch "${FILESDIR}/Build.PL.patch"
	epatch "${FILESDIR}/MDD.pm.patch"
}

src_install() {
	newinitd "${S}"/init/gentoo mdd

	perl-module_src_install
}

pkg_setup() {
	enewgroup mdd
	enewuser mdd -1 -1 /dev/null "mdd" "-r -c 'Added by MDD'"
}
