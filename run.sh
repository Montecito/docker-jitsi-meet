#!/bin/bash
unset DEBIAN_FRONTEND

export LOGDIR=/var/log/jitsi
export LOG=$LOGDIR/jvb.log

cat /etc/passwd > /tmp/passwd
echo "$(id -u):x:$(id -u):$(id -g):dynamic uid:/tmp:/bin/false" >> /tmp/passwd

cat /etc/group > /tmp/group
echo "$(id -u):x:$(id -u):" >> /tmp/group

export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/tmp/group
export LD_PRELOAD=libnss_wrapper.so

if [ ! -f "$LOG" ]; then
	
	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

	sudo dpkg-reconfigure jitsi-videobridge
	sudo rm /etc/jitsi/jicofo/config && sudo dpkg-reconfigure jicofo
	sudo /var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
	sudo dpkg-reconfigure jitsi-meet

	sudo touch $LOG && \
	sudo chown jvb:jitsi $LOG && sudo chmod -R 775 $LOGDIR
fi

cd /etc/init.d/

sudo ./prosody restart && \
sudo ./jitsi-videobridge restart && \
sudo ./jicofo restart && \
sudo ./nginx restart

tail -f $LOG