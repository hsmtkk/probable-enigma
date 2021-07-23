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
 && make -j4 \
 && make install

FROM ubuntu:20.04 AS runtime

COPY --from=builder /usr/local/squid /usr/local/squid
COPY squid.conf /usr/local/squid/etc/squid.conf

ENTRYPOINT ["/usr/local/squid/sbin/squid"]

