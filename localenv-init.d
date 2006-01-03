#!/bin/sh

PATH="/bin:/usr/bin:/sbin:/usr/sbin"
PROFILE="`/usr/bin/localenv-discover`"
PROFILE_DATA="/etc/localenv.d/"
PROFILE_FILE="${PROFILE_DATA}current_profile"

if [ ! "$PROFILE" ]; then
	echo "Internal error. Check your install. Aborting.." >&2
	exit
fi

start() {
	echo "$PROFILE" > $PROFILE_FILE
	localenv-scripts "$PROFILE" "$PROFILE_DATA"
	localenv-confs  "$PROFILE" "$PROFILE_DATA"
}

stop() {
	if [ -e $PROFILE_FILE ]; then
		rm $PROFILE_FILE
	fi
}
		
case "$1" in
	start)
		echo -n "Starting roaming profile '$PROFILE': "
		start
		echo " done."
		;;
	stop)
		echo -n "Stopping roaming profile '$PROFILE': "
		stop
		echo " done."
		;;
	restart)
		echo -n "Restarting roaming profile '$PROFILE': "
		stop
		echo -n "."
		sleep 1
		echo -n "."
		start
		echo " done."
		;;
	*)
		echo "Usage: /etc/init.d/$NAME {start|stop|restart}"
		;;
esac
