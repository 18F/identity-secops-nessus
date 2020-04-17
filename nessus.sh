#!/bin/sh

if [ -z "$LICENSE" ] ; then
	echo "no license key specified, exiting"
	exit 1
fi

# if this is a new instance of nessus, the persistent volume will be
# empty, so unpack the tarball backup of a base install into it.
if [ ! -d /opt/nessus/bin ] ; then
	echo Initializing new install of Nessus
	apt-get install /opt/Nessus.deb
fi

# Register stuff if we haven't already
if [ ! -f /opt/nessus/var/registered_flag ] ; then
	# start nessus up to get it to create it's db
	timeout 20 /opt/nessus/sbin/nessusd

	# get our license key
	/opt/nessus/sbin/nessuscli fetch --register "$LICENSE"

	touch /opt/nessus/var/registered_flag
	echo "you should be able to ssh into this pod and run '/opt/nessus/sbin/nessuscli adduser <username>' to seed users"
	echo "XXX someday, get these from secrets?"
fi

# start the nessus service up in a way that gets us stdout logging of everything
# XXX this results in ugly logs since it's 4 different formats, has tail headers, etc.
tail --follow=name --retry /opt/nessus/var/nessus/logs/* &
exec /opt/nessus/sbin/nessus-service
