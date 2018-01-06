#!/bin/sh
#
#
# (c) 2017 nimmis <kjell.havenskold@gmail.com>

BASEDIR=$(dirname "$0")

RUN_NAME=$1
RUN_TAG=$2
RETURN_VAL=0

echo "----Build---"
$BASEDIR/build.sh  $RUN_NAME $RUN_TAG

if [ "$?" = "0" ]; then
   echo "----TEST---"
   $BASEDIR/test.sh $RUN_NAME $RUN_TAG
   RETURN_VAL=$?

   echo "----Clean up----"
   RET=$(docker rmi $RUN_NAME:$RUN_TAG)
   if [ ! "$?" = "0" ]; then
     echo "Remove FAILED:$RET"
   fi
else
  RETURN_VAL=1
fi

exit $RETURN_VAL
