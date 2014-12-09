#!/bin/bash

######################################
##									##
##		Made by William Rudent		##
##									##
######################################

clear

if [ "$(id -u)" != "0" ]; then
	echo
	echo "This script must be run as root." 1>&2
	echo
	exit 1
fi

# Setting up variables

ENV_USER = "root"
ENV_HOMEDIR = "/root"

# Setting up home directory for rtorrent

cd /home
mkdir .rtorrent
cd .rtorrent
mkdir current
mkdir session
touch rtorrent.log

# Server update
apt-get update && apt-get upgrade -y

# Install library
apt-get install -y build-essential libsigc++-2.0-dev libcurl4-openssl-dev automake libtool libcppunit-dev libncurses5-dev unrar-free unzip zip ffmpeg curl screen git 

# Install Libtorrent and Rtorrent
apt-get install -y rtorrent

# Configuring rtorrent
cd /root
wget https://dev.vigitas.com/vcid-rt8d4f7e9r-fr/rtorrent.zip
unzip rtorrent.zip
rm rtorrent.apache
rm rtorrent
rm rtorrent.zip
chown "$ENV_USER":"$ENV_USER" $ENV_HOMEDIR/.rtorrent.rc

# Installation of mediainfo for rutorrent
apt-get install -y mediainfo

# Installation of Rutorrent
cd /usr/share/
mkdir rutorrent
cd rutorrent/
wget https://rutorrent.googlecode.com/files/rutorrent-3.5.tar.gz
tar xvzf rutorrent-3.5.tar.gz
rm rutorrent-3.5.tar.gz
mv rutorrent/* ./
rm -Rf ruttorent
cd plugins/
wget https://rutorrent.googlecode.com/files/plugins-3.5.tar.gz
tar xvzf plugins-3.5.tar.gz
rm plugins-3.5.tar.gz
mv plugins/* ./
chown -R "$ENV_USER":"$ENV_USER" /usr/share/rutorrent

# Configuring apache and init.d daemon
cd /etc/init.d
wget https://dev.vigitas.com/vcid-rt8d4f7e9r-fr/rtorrent.zip
unzip rtorrent.zip
mv rtorrent.apache /etc/apache2/sites-available/
rm rtorrent.zip
chmod 0777 rtorrent

# Starting rtorrent and configuring vhosts
/etc/init.d/rtorrent start
a2ensite rtorrent.apache

# Finalizing and finishing
/etc/init.d/apache2 reload
/etc/init.d/apache2 restart
/etc/init.d/rtorrent stop
/etc/init.d/rtorrent start

# Echo box and rules process
clear
echo -e "[ \033[0;32;148mok\033[39m ] Installation completed"
echo -e "[ \033[0;32;148mok\033[39m ] starting rtorrent..."

ip=$(ip addr | grep eth0 | grep inet | awk '{print $2}' | cut -d/ -f1)
echo -e "[ info ] copy/paste this url : http://$ip/torrent"

