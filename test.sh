#!/bin/sh
#
# Test that Nessus runs.  It can't activate because it probably won't have a LICENSE,
# but that's probably OK.  We just want to make sure it installs and runs.
#
# Run this inside the container to test it out.  Something like this:
#   docker run -e LICENSE=XXXX-XXXX-XXXX-XXXX-XXXX <image> /usr/bin/test.sh
#

# Fire it up and run for 60 seconds to see if it worked.
timeout 60 /usr/bin/nessus.sh > /tmp/test.out


# Check that webserver is running
if grep 'WebServer service is running' /opt/nessus/var/nessus/logs/nessusd.messages >/dev/null ; then
	echo "webserver worked"
else
	echo "webserver failed"
	cat /opt/nessus/var/nessus/logs/nessusd.messages
	exit 1
fi

# Check that Nessus is running
if grep 'Nessus is ready' /opt/nessus/var/nessus/logs/nessusd.messages >/dev/null ; then
	echo "Nessus worked"
else
	echo "Nessus failed"
	cat /opt/nessus/var/nessus/logs/nessusd.messages
	exit 1
fi

# by default, exit happy
exit 0
