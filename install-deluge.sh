#!/bin/sh

# This script will install the latest version of the BitTorrent client Deluge on your Western Digital My Book Live.
# The script was created for personal use and is based on these guides:
# http://dev.deluge-torrent.org/wiki/Installing/Linux/Debian/Lenny
# http://dev.deluge-torrent.org/wiki/UserGuide/InitScript/Ubuntu

# Author: Andrea Ferrato - ferra.andre@gmail.com
# ver. 0.1

#Setting the variables with the contents of the files I create later
deluge_daemon_default='# Configuration for /etc/init.d/deluge-daemon

# The init.d script will only run if this variable non-empty.
DELUGED_USER="root"
# Should we run at startup?
RUN_AT_STARTUP="YES"'

deluge_daemon_init='    #!/bin/sh

################################################################################
# Don t forget to chmod the script and update your init.
#
# chmod +x /etc/init.d/deluge-daemon
# update-rc.d -f deluge-daemon defaults
#
################################################################################

    ### BEGIN INIT INFO
    # Provides:          deluge-daemon
    # Required-Start:    $local_fs $remote_fs
    # Required-Stop:     $local_fs $remote_fs
    # Should-Start:      $network
    # Should-Stop:       $network
    # Default-Start:     2 3 4 5
    # Default-Stop:      0 1 6
    # Short-Description: Daemonized version of deluge and webui.
    # Description:       Starts the deluge daemon with the user specified in
    #                    /etc/default/deluge-daemon.
    ### END INIT INFO

    # Author: Adolfo R. Brandes <arbrandes@gmail.com>

    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    DESC="Deluge Daemon"
    NAME1="deluged"
    NAME2="deluge"
    DAEMON1=/usr/bin/deluged
    DAEMON1_ARGS="-d"
    DAEMON2=/usr/bin/deluge
    DAEMON2_ARGS="-u web"
    PIDFILE1=/var/run/$NAME1.pid
    PIDFILE2=/var/run/$NAME2.pid
    PKGNAME=deluge-daemon
    SCRIPTNAME=/etc/init.d/$PKGNAME

    # Exit if the package is not installed
    [ -x "$DAEMON1" -a -x "$DAEMON2" ] || exit 0

    # Read configuration variable file if it is present
    [ -r /etc/default/$PKGNAME ] && . /etc/default/$PKGNAME

    # Load the VERBOSE setting and other rcS variables
    [ -f /etc/default/rcS ] && . /etc/default/rcS

    # Define LSB log_* functions.
    # Depend on lsb-base (>= 3.0-6) to ensure that this file is present.
    . /lib/lsb/init-functions

    if [ -z "$RUN_AT_STARTUP" -o "$RUN_AT_STARTUP" != "YES" ]
    then
       log_warning_msg "Not starting $PKGNAME, edit /etc/default/$PKGNAME to start it."
       exit 0
    fi

    if [ -z "$DELUGED_USER" ]
    then
        log_warning_msg "Not starting $PKGNAME, DELUGED_USER not set in /etc/default/$PKGNAME."
        exit 0
    fi

    #
    # Function that starts the daemon/service
    #
    do_start()
    {
       # Return
       #   0 if daemon has been started
       #   1 if daemon was already running
       #   2 if daemon could not be started
       start-stop-daemon --start --background --quiet --pidfile $PIDFILE1 --exec $DAEMON1 \
          --chuid $DELUGED_USER --user $DELUGED_USER --test > /dev/null
       RETVAL1="$?"
       start-stop-daemon --start --background --quiet --pidfile $PIDFILE2 --exec $DAEMON2 \
          --chuid $DELUGED_USER --user $DELUGED_USER --test > /dev/null
       RETVAL2="$?"
       [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] || return 1

       start-stop-daemon --start --background --quiet --pidfile $PIDFILE1 --make-pidfile --exec $DAEMON1 \
          --chuid $DELUGED_USER --user $DELUGED_USER -- $DAEMON1_ARGS
       RETVAL1="$?"
            sleep 2
       start-stop-daemon --start --background --quiet --pidfile $PIDFILE2 --make-pidfile --exec $DAEMON2 \
          --chuid $DELUGED_USER --user $DELUGED_USER -- $DAEMON2_ARGS
       RETVAL2="$?"
       [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] || return 2
    }

    #
    # Function that stops the daemon/service
    #
    do_stop()
    {
       # Return
       #   0 if daemon has been stopped
       #   1 if daemon was already stopped
       #   2 if daemon could not be stopped
       #   other if a failure occurred
       
       start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $DELUGED_USER --pidfile $PIDFILE2
       RETVAL2="$?"
       start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --user $DELUGED_USER --pidfile $PIDFILE1
       RETVAL1="$?"
       [ "$RETVAL1" = "2" -o "$RETVAL2" = "2" ] && return 2

       rm -f $PIDFILE1 $PIDFILE2

       [ "$RETVAL1" = "0" -a "$RETVAL2" = "0" ] && return 0 || return 1
    }


    case "$1" in
      start)
       [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME1"
       do_start
       case "$?" in
          0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
          2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
       esac
       ;;
      stop)
       [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME1"
       do_stop
       case "$?" in
          0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
          2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
       esac
       ;;
      restart|force-reload)
       log_daemon_msg "Restarting $DESC" "$NAME1"
       do_stop
       case "$?" in
         0|1)
          do_start
          case "$?" in
             0) log_end_msg 0 ;;
             1) log_end_msg 1 ;; # Old process is still running
             *) log_end_msg 1 ;; # Failed to start
          esac
          ;;
         *)
            # Failed to stop
          log_end_msg 1
          ;;
       esac
       ;;
      *)
       echo -e "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
       exit 3
       ;;
    esac

    :
'

# Making a backup of the file /etc/apt/sources.list
echo -e "$(tput bold)$(tput setaf 6)I make a backup of the file /etc/apt/sources.list$(tput sgr0)"
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Asking the user if he wants to continue with the installation
read -p "$(tput bold)$(tput setaf 6)This script will modify your sources.list (has already created a backup) inserting the repository you need to install the latest version of Deluge. Are you sure you want to continue? [y-n] $(tput sgr0)"
if [ "$REPLY" == "y" ] 

then
# Looking for Squeeze repository in the sources.list 
if grep -Fxq "deb http://ftp.us.debian.org/debian/ squeeze main" /etc/apt/sources.list
	then
		read -p "$(tput bold)$(tput setaf 6)To avoid incompatibilities you should limit to lenny packages, comments all repositories except Lenny? [y-n] $(tput sgr0)"
			if [ "$REPLY" == "y" ] 
				then
					echo -e "$(tput bold)$(tput setaf 6)Commenting all repositories except Lenny$(tput sgr0)"
					sed -i  '/lenny/!s/deb /#deb /g' /etc/apt/sources.list
# Removing the double comments
					sed -i 's/##deb /#deb /g' /etc/apt/sources.list 
				else
					read -p "$(tput bold)$(tput setaf 6)Sure you do not want to comment them? [y-n]$(tput sgr0)"
					if [ "$REPLY" == "y" ] 
						then
							echo -e "$(tput bold)$(tput setaf 6)I will not comment all repositories except Lenny$(tput sgr0)"
						else
							echo -e "$(tput bold)$(tput setaf 6)Commenting all repositories except Lenny$(tput sgr0)"
							sed -i '/lenny/!s/deb /#deb /g' /etc/apt/sources.list
# Removing the double comments
							sed -i 's/##deb /#deb /g' /etc/apt/sources.list 
					fi

			fi
	fi 
# Looking for Lenny repository in the sources.list 
if grep "deb http://archive.debian.org/debian/ lenny main" /etc/apt/sources.list
	then
		echo -e "$(tput bold)$(tput setaf 6)deb http://archive.debian.org/debian/ lenny main is already available in the sources.list$(tput sgr0)"
	else
		echo -e "$(tput bold)$(tput setaf 6)Adding Lenny repository to sources.list$(tput sgr0)"
		echo -e "\n\n#Added by the installation script of Deluge \ndeb http://archive.debian.org/debian/ lenny main" >> /etc/apt/sources.list
fi

echo -e "$(tput bold)$(tput setaf 6)I create the new sources.list for Deluge$(tput sgr0)"
echo -e "#Sourcest.list generated by the installation script of Deluge \n \n deb http://ftp.us.debian.org/debian/ squeeze main contrib non-free \n deb-src http://ftp.us.debian.org/debian/ squeeze main contrib non-free \n \n deb http://ppa.launchpad.net/deluge-team/ppa/ubuntu lucid main \n deb-src http://ppa.launchpad.net/deluge-team/ppa/ubuntu lucid main" > /etc/apt/sources.list.d/deluge.list

echo -e "$(tput bold)$(tput setaf 6)I create the file /etc/apt/preferences$(tput sgr0)"

echo -e "Package: * \n Pin: release a=stable \n Pin-Priority: 700  \n \n Package: * \n Pin: release a=testing \n Pin-Priority: 650" > /etc/apt/preferences

# Recovering and adding the GPG keys
apt-key adv --recv-keys --keyserver subkeys.pgp.net 249AD24C
apt-key adv --recv-keys --keyserver subkeys.pgp.net AED4B06F473041FA
apt-key adv --recv-keys --keyserver subkeys.pgp.net 64481591B98321F9

echo -e "$(tput bold)$(tput setaf 6)Updating apt$(tput sgr0)"
apt-get update

echo -e "$(tput bold)$(tput setaf 6)Installing python-libtorrent$(tput sgr0)"
aptitude install -y python-libtorrent

echo -e "$(tput bold)$(tput setaf 6)Installing deluge deluged deluge-web deluge-console$(tput sgr0)"
sudo apt-get install -y -t lucid deluge deluged deluge-web deluge-console

echo -e "$(tput bold)$(tput setaf 6)I create the file /etc/default/deluge-daemon$(tput sgr0)"
echo -e "$deluge_daemon_default" > "/etc/default/deluge-daemon"

echo -e "$(tput bold)$(tput setaf 6)I create the file /etc/init.d/deluge-daemon$(tput sgr0)"
echo -e "$deluge_daemon_init" > "/etc/init.d/deluge-daemon"


echo -e "$(tput bold)$(tput setaf 6)Changing the permissions to /etc/init.d/deluge-daemon$(tput sgr0)"
sudo chmod +x /etc/init.d/deluge-daemon

echo -e "$(tput bold)$(tput setaf 6)Adding the service at boot$(tput sgr0)"
update-rc.d deluge-daemon defaults

#echo -e "Deluge Authentication"
#echo -e "root:password:10" > ~/.config/deluge/auth

echo -e "$(tput bold)$(tput setaf 6)Launching the daemon$(tput sgr0)"
invoke-rc.d deluge-daemon start

echo -e "$(tput bold)$(tput setaf 6)All done! go to http://ip.my.book.live:8112 and enjoy!$(tput sgr0)"

else exit 0
fi

