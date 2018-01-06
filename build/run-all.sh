#!/bin/sh
#
# loop thru all versions
#
# (c) 2017 nimmis <kjell.havenskold@gmail.com>
#

#RUN_CON_NAME="nimmis/consul"

SUCCESS_RUN=""
FAIL_RUN=""

BASEDIR=$(dirname "$0")


. $BASEDIR/settings.conf


TAGS=$(ls -1l | grep ^d | grep -v build$ | awk '{print $NF}')

if [ -L latest ] ; then
  TAGS="$TAGS latest"
fi

if [ -L beta ] ; then
  TAGS="$TAGS beta"
fi

if [ -L test ] ; then
  TAGS="$TAGS test"
fi

for TAG in $TAGS; do
  echo "***** $BASEDIR/run.sh $RUN_CON_NAME $TAG"
  $BASEDIR/run.sh $RUN_CON_NAME $TAG
  if [ "$?" = "0" ]; then
     SUCCESS_RUN="$SUCCESS_RUN$TAG "
  else
     FAIL_RUN="$FAIL_RUN$TAG "
  fi 
done

echo "----- RESULT -----"
echo "SUCCESSFUL TAGS: $SUCCESS_RUN"
echo "FAIL TAGS      : $FAIL_RUN"

