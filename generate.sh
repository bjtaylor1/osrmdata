mkfs /dev/nvme1n1
mkdir /bigdisk
mount /dev/nvme1n1 /bigdisk
chown -R ubuntu:ubuntu /bigdisk
apt-get update

apt -y install build-essential git cmake pkg-config libbz2-dev libstxxl-dev libstxxl1v5 libxml2-dev libzip-dev libboost-all-dev lua5.2 liblua5.2-dev libtbb-dev libluabind-dev libluabind0.9.1d1 awscli


#build osrm rather than downloading it:
#sudo -u ubuntu git clone https://github.com/bjtaylor1/osrm-backend.git
#(
#cd osrm-backend
#sudo -u ubuntu mkdir -p build
#cd build
#sudo -u ubuntu cmake .. -DCMAKE_BUILD_TYPE=Release
#sudo -u ubuntu cmake --build .
#cmake --build . --target install
#return to main dir

aws configure set aws_access_key_id AKIAVI2BFBSAV4VPSTXO
aws configure set aws_secret_access_key 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

cd /bigdisk

git clone git@github.com/bjtaylor1/osrmdata
git clone git@github.com/bjtaylor1/polymaker
git clone git@github.com/bjtaylor1/osrm-backend

cd osrm-backend
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

cd /bigdisk
wget https://planet.openstreetmap.org/pbf/planet-latest.osm.pbf

