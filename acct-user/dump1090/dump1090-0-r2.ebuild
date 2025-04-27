# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="dump1090 program user"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( dump1090 usb plugdev )
acct-user_add_deps
