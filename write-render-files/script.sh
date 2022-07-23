#!/bin/bash
set -x
## Process input render var into array
TMPIFS=$IFS
IFS=$'\n' 
files=(${RENDER})
IFS=$TMPIFS

echo ::debug::$(ls -lhR)
## Change Dir to catalog
pushd ${DIR}
echo ::debug::$(ls -lhR)

## Delete existing catalog dir
find ./ -name "*.json" -depth 1 -type f -delete

## Iterate over input array
for data in ${files[@]}
do
    ## Set filename from schema
    file="$(echo $data | jq .schema)"
    file="$(echo $file | sed s/\"olm\.\\\(\[a\-z\]*\\\)\"/\\1.json/)"

    ## Write File 
    echo $data >> $file
done

## Write icon and description Files
echo -n $ICON | base64 -d > iconfile
echo -n $DESC | base64 -d > descriptionfile

popd