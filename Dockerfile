FROM ubuntu:20.04 AS builder

RUN apt-get -y update \
 && apt-get -y --no-install-recommends install curl gcc g++ make perl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L http://www.squid-cache.org/Versions/v4/squid-4.16.tar.bz2 \
 | tar -xj -C /usr/local/src

WORKDIR /usr/local/src/squid-4.16

RUN ./configure --prefix=/usr/local/squid \
 && make \
 && make install

