FROM ubuntu:focal
ENV TGTDIR=/usr/local/bin
RUN env LANG=C LC_ALL=C apt-get update
RUN env DEBIAN_FRONTEND=noninteractive LANG=C LC_ALL=C apt-get -y full-upgrade
RUN env DEBIAN_FRONTEND=noninteractive LANG=C LC_ALL=C apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install wget
VOLUME /zims
COPY ./scripts/*.sh $TGTDIR/
RUN provision.sh
EXPOSE 8080
ENTRYPOINT ["entrypoint.sh"]
