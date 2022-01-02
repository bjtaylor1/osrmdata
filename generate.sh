#!/bin/bash

(
set -e
set -x

echo $$
mkfs /dev/nvme1n1
mkdir /bigdisk
mount /dev/nvme1n1 /bigdisk
apt-get update

apt -y install build-essential git cmake pkg-config libbz2-dev libstxxl-dev libstxxl1v5 libxml2-dev libzip-dev libboost-all-dev lua5.2 liblua5.2-dev libtbb-dev libluabind-dev libluabind0.9.1d1 awscli osmosis

aws configure set aws_access_key_id <access key>
aws configure set aws_secret_access_key <secret key>

cd /bigdisk

git clone https://github.com/bjtaylor1/osrmdata
git clone https://github.com/bjtaylor1/polymaker
git clone https://github.com/bjtaylor1/osrm-backend

cd osrm-backend
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

cd /bigdisk
wget https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf

/bigdisk/osrmdata/processplanet.sh /bigdisk/planet-latest.osm.pbf

shutdown -h now
) > /init.log 2>&1