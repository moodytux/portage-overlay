#!/sbin/openrc-run
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

extra_commands="scan"

depend() {
	use net
}

start() {
	ebegin "Starting mopidy"
	start-stop-daemon --start --quiet -m --pidfile /var/run/mopidy.pid \
		--background --exec /usr/bin/mopidy -- --config /etc/mopidy/mopidy.conf --save-debug-log
	eend $? "Failed to start mopidy."
}

stop() {
	ebegin "Stopping mopidy"
	start-stop-daemon --stop --quiet --pidfile /var/run/mopidy.pid
	eend $?
}

scan() {
	ebegin "Scanning for local music"
	if [ -f /var/run/mopidy.pid ]; then
		eerror "Please stop the mopidy server before scanning" 
	else
		/usr/bin/mopidy --config /etc/mopidy/mopidy.conf local scan
	fi
	eend $?
}
