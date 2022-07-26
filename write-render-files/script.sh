#!/bin/bash
set -x
## Process input render var into array
TMPIFS=$IFS
IFS=$'\n' 
files=(${RENDER})
IFS=$TMPIFS

echo ::debug::$(ls -lhR)
## Change Dir to catalog
sudo chmod -Rv --preserve-root a+rwX ${DIR}
pushd ${DIR}

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
if [ "$ICON" != "" ] ; then
    echo -n $ICON | base64 -d > iconfile
else
    touch iconfile
fi
if [ "$DESC" != "" ]; then 
    echo -n $DESC | base64 -d > descriptionfile
else
    touch descriptionfile
fi

popd