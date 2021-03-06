FROM pgrouting/pgrouting:12-3.0-master

LABEL maintainer="<louis, landrinaivo740@gmail.com>"

ENV PGROUTING_VERSION 3.1.1
ENV PGROUTING_SHA256 b32e50269c79d65cb31bc611473c2ff0f9948b1a15dcaeef077ffcdfbd1c2730

RUN set -ex \
 && apt update \
 && apt install -y \
        libboost-atomic1.67.0 \
        libboost-chrono1.67.0 \
        libboost-graph1.67.0 \
        libboost-date-time1.67.0 \
        libboost-program-options1.67.0 \
        libboost-system1.67.0 \
        libboost-thread1.67.0 \
        libcgal13 \
 && apt install -y \
        build-essential \
        cmake \
        wget \
        libboost-graph-dev \
        libcgal-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && wget -O pgrouting.tar.gz "https://github.com/pgRouting/pgrouting/archive/v${PGROUTING_VERSION}.tar.gz" \
 && echo "$PGROUTING_SHA256 *pgrouting.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/pgrouting \
 && tar \
        --extract \
        --file pgrouting.tar.gz \
        --directory /usr/src/pgrouting \
        --strip-components 1 \
 && rm pgrouting.tar.gz \
 && cd /usr/src/pgrouting \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make \
 && make install \
 && cd / \
 && rm -rf /usr/src/pgrouting \
 && apt-mark manual postgresql-13 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        wget \
        libcgal-dev \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*
RUN rm /docker-entrypoint-initdb.d/10_postgis.sh

################################################################
################# PGROUTING ####################################
################################################################

WORKDIR /usr/src/app

# Requirement for converting osm to pgrouting 
RUN apt-get update && apt-get upgrade -y\
    && apt-get install -y expat libexpat1-dev libboost-dev libboost-program-options-dev \
    libpqxx-dev cmake git gcc g++ curl

RUN git clone https://github.com/pgRouting/osm2pgrouting.git

RUN cd osm2pgrouting \
    && cmake -H. -Bbuild \
    && cd build \
    && make \
    && make install

RUN rm -rf osm2pgrouting

RUN curl http://m.m.i24.cc/osmconvert.c -o osmconvert.c

RUN cc osmconvert.c -lz -o /usr/local/bin/osmconvert

RUN rm -rf osmconvert.c

RUN chown -R postgres:postgres /usr/src/app/

RUN mkdir -p /usr/src/app/

ADD . /usr/src/app/tools

RUN mkdir /home/scripts

RUN chown -R postgres:postgres /home/

USER postgres

WORKDIR /home/


