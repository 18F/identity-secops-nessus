#!/bin/sh

if [ -z "$LICENSE" ] ; then
	echo "no license key specified, exiting"
	exit 1
fi

# if this is a new instance of nessus, the persistent volume will be
# empty, so unpack the tarball backup of a base install into it.
#
# Otherwise, do an upgrade on the existing volume, in case we have a
# new version.
if [ ! -d /opt/nessus/bin ] ; then
	echo Initializing new install of Nessus
	apt-get install /opt/Nessus.deb
else
	echo upgrading nessus with package just to be sure
	apt-get upgrade /opt/Nessus.deb
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

# start the nessus service up in a way that gets us stdout logging
exec /opt/nessus/sbin/nessus-service
