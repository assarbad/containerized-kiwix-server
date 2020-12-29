FROM ubuntu:focal
RUN apt update
RUN apt -y full-upgrade
RUN apt -y install wget
WORKDIR /
COPY ./zims ./zims
COPY ./scripts ./scripts
RUN ./scripts/provision.sh
RUN ./scripts/makelibrary.sh
EXPOSE 8080
ENTRYPOINT ["kiwix-serve", "--port",  "8080", "--library", "/library.xml"]
