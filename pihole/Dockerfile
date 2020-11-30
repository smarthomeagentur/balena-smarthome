FROM pihole/pihole:v5.1.2-armhf-stretch

WORKDIR /usr/src
ENV DEBIAN_FRONTEND noninteractive

RUN sed '/$AUTHORIZED_HOSTNAMES = array(/ a "balena-devices.com",' -i /var/www/html/admin/scripts/pi-hole/php/auth.php
RUN echo "bind-interfaces" >> /etc/dnsmasq.conf
SHELL ["/bin/bash", "-o", "pipefail", "-c"]