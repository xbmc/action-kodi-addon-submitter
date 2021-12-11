#!/bin/sh -l

# Add sub directory parameter if required
if [ "$5" = true ] ; then
  SUBDIRECTORY="-s"
else
  SUBDIRECTORY=""
fi

if [ "$4" = true ] ; then
  submit-addon -z $3 -m $SUBDIRECTORY
  echo ::set-output name=addon-zip::$(ls *.zip | awk '$0 !~ /\+matrix\./')
  echo ::set-output name=addon-zip-matrix::$(ls *+matrix*.zip)
  submit-addon -r $1 -b $2 --pull-request $3 -m $SUBDIRECTORY
else
  submit-addon -z $3 $SUBDIRECTORY
  echo ::set-output name=addon-zip::$(ls *.zip)
  echo ::set-output name=addon-zip-matrix::
  submit-addon -r $1 -b $2 --pull-request $3 $SUBDIRECTORY
fi
