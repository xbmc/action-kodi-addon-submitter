#!/bin/sh -l
if [ "$4" = true ] ; then
  # addon zip
  submit-addon -z $3 -m
  echo ::set-output name=addon-zip::$(ls *.zip | awk '$0 !~ /\+matrix\./')
  echo ::set-output name=addon-zip-matrix::$(ls *+matrix*.zip)
  # addon pull request
  submit-addon -r $1 -b $2 --pull-request $3 -m
else
  submit-addon -z $3
  echo ::set-output name=addon-zip::$(ls *.zip)
  echo ::set-output name=addon-zip-matrix::
  submit-addon -r $1 -b $2 --pull-request $3
fi
