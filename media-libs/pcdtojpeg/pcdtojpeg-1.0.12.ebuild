# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Decoder to convert PCD (Kodak Photo CD) to JPEGs without blown highlights or colour casts"
HOMEPAGE="http://pcdtojpeg.sourceforge.net/Home.html"
SRC_URI="http://downloads.sourceforge.net/project/pcdtojpeg/pcdtojpeg/pcdtojpeg%20${PV}/pcdtojpeg_${PV//./_}.zip?r=&ts=1443959894&use_mirror=netcologne -> pcdtojpeg-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="${RDEPEND}"
RDEPEND=""

src_unpack() {
        unpack ${A}
        cd ${PN}_${PV//./_}
        S=`pwd`
		echo ${S}
}

src_compile() {
		cd ${S}/src
		g++ main.cpp pcdDecode.cpp -ljpeg -lpthread -o pcdtojpeg
}

src_install() {
		dodir "/usr/bin"
		cp "${S}/src/pcdtojpeg" "${D}/usr/bin/" || die "Install failed!"
}
