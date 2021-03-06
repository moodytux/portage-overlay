# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs readme.gentoo-r1 tmpfiles

DESCRIPTION="Simple Mode S decoder for RTLSDR devices"
HOMEPAGE="https://github.com/flightaware/dump1090"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightaware/${PN}.git"
else
	KEYWORDS="amd64 x86"
	SRC_URI="https://github.com/flightaware/dump1090/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
IUSE="bladerf +rtlsdr lighttpd"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	virtual/libusb:1
	bladerf? ( net-wireless/bladerf:= )
	rtlsdr? ( net-wireless/rtl-sdr:= )
	lighttpd? (
		www-servers/lighttpd:=
		acct-user/dump1090:=
		acct-group/dump1090:=
	)"
RDEPEND="${DEPEND}"

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="
In order to enable lighttpd integration, add:

		include \"/usr/share/dump1090-fa/lighttpd.conf\"

onto the end of /etc/lighttpd/lighttpd.conf.

Also, if you don't already have mod_alias enabled, you will
need to enable it in the same file.
"

src_prepare() {
	default
	sed -i -e 's#-O3 -g -Wall -Wmissing-declarations -Werror -W##' Makefile || die
	sed -i -e "s#-lncurses#$($(tc-getPKG_CONFIG) --libs ncurses)#" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" \
		BLADERF=$(usex bladerf) \
		RTLSDR=$(usex rtlsdr)
}

src_install() {
	dobin ${PN}
	dobin view1090
	dodoc README.md
	readme.gentoo_create_doc

	insinto /usr/share/${PN}-fa/html
	doins -r public_html/*

	insinto /usr/share/${PN}-fa
	doins -r tools

	if use lighttpd; then
		insinto /usr/share/${PN}-fa
		newins debian/lighttpd/89-dump1090-fa.conf lighttpd.conf

		newinitd "${FILESDIR}"/dump1090.initd-r1 dump1090

		newtmpfiles "${FILESDIR}"/${PN}-tmpfiles ${PN}.conf
	fi
}

pkg_postinst() {
	if use lighttpd; then
		tmpfiles_process /usr/lib/tmpfiles.d/dump1090.conf

		readme.gentoo_print_elog
	fi
}

