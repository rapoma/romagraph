#!/bin/bash


echo
echo "download from osm"
echo
set -x
curl http://download.geofabrik.de/europe/italy/centro-latest.osm.pbf -o /home/dati/centro-latest.osm.pbf
set +x
echo 
echo "finish downloading"
echo

echo
echo "converting the pbf to osm"
echo
set -x
osmconvert /home/dati/centro-latest.osm.pbf -b=12.439499,41.847969,12.54158,41.914174 > /home/dati/roma.osm
set +x
echo 
echo "finish conversion"
echo


echo
echo "create a databse"
echo
set -x
createdb romaroute
psql -d romaroute -c "create extension postgis"
psql -d romaroute -c "create extension pgrouting"
set +x
echo 
echo "finish database"
echo

echo
echo "################################"
echo "#####starting populate db ######"
echo 


if [ -f /home/dati/roma.osm ]; then
set -x
osm2pgrouting --file /home/dati/roma.osm \
                                --conf /usr/src/app/tools/mapconfig_for_pedestrian.xml \
                                --dbname romaroute \
                                --username postgres \
                                --password password \
                                --clean

set +x
else
echo "Aborting , file doesnot exist ##"
echo
exit 1
fi

echo
echo "########### finish #############"
echo "################################"
echo