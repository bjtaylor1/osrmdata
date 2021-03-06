#!/bin/bash

# pass the FULL path of the file, not relative! it accesses it from subdirs!

set -e
set -x

startdir=$(pwd)
echo $startdir

for letter in A B C D E F; do
    rm -rf $letter
    mkdir $letter
    (
        cd $letter #extract arranges the files in the same directory as the .osm.pbf file, no matter what directory we're currently in
        
        osmosis --read-pbf file="$1" --bounding-polygon file=/bigdisk/polymaker/$letter.poly --write-pbf file="$letter.osm.pbf"
        #cp $1 $letter.osm.pbf (small, e.g. liechtenstein, monaco etc, to avoid extract not finding any streets)

        /bigdisk/osrm-backend/build/osrm-extract $letter.osm.pbf -p /bigdisk/osrm-backend/profiles/bicycle.lua
        /bigdisk/osrm-backend/build/osrm-contract $letter.osrm
        rm $letter.osm.pbf
        tar -zcvf ../$letter.tar.gz *
    )
    rm -rf $letter
    rm -rf $letter"_parts"
    mkdir $letter"_parts"
    (
        cd $letter"_parts"
        split -b 10000000 -a 5 ../$letter.tar.gz
        rm ../$letter.tar.gz
        aws s3 rm --recursive s3://osrmtransfer1/$letter"_parts"
        aws s3 sync . s3://osrmtransfer1/$letter"_parts"
    )
    rm -rf $letter"_parts"
done