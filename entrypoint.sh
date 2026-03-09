#!/bin/sh -l

# Add sub directory parameter if required
if [ "$5" = true ] ; then
  SUBDIRECTORY="-s"
else
  SUBDIRECTORY=""
fi

if [ "$4" = true ] ; then
  submit-addon -z $3 -m $SUBDIRECTORY
  echo "addon-zip=$(ls *.zip | awk '$0 !~ /\+matrix\./')" >> $GITHUB_OUTPUT
  echo "addon-zip-matrix=$(ls *+matrix*.zip)" >> $GITHUB_OUTPUT
  submit-addon -r $1 -b $2 --pull-request $3 -m $SUBDIRECTORY
else
  submit-addon -z $3 $SUBDIRECTORY
  echo "addon-zip=$(ls *.zip)" >> $GITHUB_OUTPUT
  echo "addon-zip-matrix=" >> $GITHUB_OUTPUT
  submit-addon -r $1 -b $2 --pull-request $3 $SUBDIRECTORY
fi
