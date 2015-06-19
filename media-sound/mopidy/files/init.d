#!/sbin/runscript
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

depend() {
	use net
}

start() {
	ebegin "Starting mopidy"
	/usr/bin/mopidy local scan
	start-stop-daemon --start --quiet -m --pidfile /var/run/mopidy.pid \
		--background --exec /usr/bin/mopidy
	eend $? "Failed to start mopidy."
}

stop() {
	ebegin "Stopping mopidy"
	start-stop-daemon --stop --quiet --pidfile /var/run/mopidy.pid
	eend $?
}
