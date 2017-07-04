FROM debian:latest

MAINTAINER M0nt3c1t0 <montecito.games@gmail.com>

ENV RUN_USER 777
ENV RUN_GROUP 0
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

RUN apt-get update && \
	apt-get install -y sudo libnss-wrapper wget dnsutils vim telnet nano curl apt-transport-https gnupg && \
	sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list" && \
	wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add - && \
	apt-get update && \
	apt-get -y install jitsi-meet && \
	apt-get clean

RUN useradd --uid 777 -m -g jitsi -G root -s /bin/bash jitsi-meet && \
	echo "%root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
	echo "ALL ALL=NOPASSWD: /usr/sbin/service" >> /etc/sudoers

#RUN adduser jitsi root
#ENV PUBLIC_HOSTNAME=192.168.59.103

#/etc/jitsi/meet/localhost-config.js = bosh: '//localhost/http-bind',
#RUN sed s/JVB_HOSTNAME=/JVB_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/videobridge/config && \
#	sed s/JICOFO_HOSTNAME=/JICOFO_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/jicofo/config

EXPOSE 80 443 5347
#EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

COPY run.sh /run.sh

USER ${RUN_USER}:${RUN_GROUP}
CMD /run.sh