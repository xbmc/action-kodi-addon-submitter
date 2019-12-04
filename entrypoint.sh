#!/bin/sh -l
submit-addon -z $3
echo ::set-output name=addon-zip::$(ls *.zip)
submit-addon -r $1 -b $2 --pull-request $3