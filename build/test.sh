#!/bin/sh

EXTERNAL_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
DOCKER_IP=$(/sbin/ifconfig docker0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
CONTAINER_NAME="$1:$2"
TAG="$2"

create_container() {

  echo -n "Creating container ($CONTAINER_NAME) .. "

  CONTAINER=$(docker run -d -h $1-$2-test $CONTAINER_NAME 2>&1)

  if [ "$?" = "0" ]; then
    echo "OK"
  else
    echo "FAIL:$CONTAINER"
    EXIT_STATUS=1
  fi

}

delete_container() {

  echo -n "Deleting container .. "

  RET=$(docker rm -f $CONTAINER)

  if [ "$?" = "0" ]; then
     echo "OK"
  else
     echo "FAIL:$RET"
     EXIT_STATUS=255
  fi

}

test_container() {

  # check for /bin/sh executes

  echo -n "Testing /bin/sh in container .. "
  RET=$(docker exec $CONTAINER /bin/sh -c 'echo "TEST-OK"')

  if [ "$?" = "0" ]; then
     if [ "$RET" = "TEST-OK" ]; then
       echo "OK"
     else
       echo "FAIL wrong return from command (TEST-OK):$RET"
       EXIT_STATUS=255
     fi
  else
     echo "FAIL execure docker command:$RET"
     EXIT_STATUS=255
  fi

  echo -n "Check for correct verion of OS.."
  VER_TEST=$(docker exec $CONTAINER /bin/sh -c 'cat /etc/alpine-release')

  if echo $TAG | egrep -q ^[0-9].* ; then

    if echo $VER_TEST | egrep -q ^${TAG} ; then
      echo "OK"
    else
      echo "Version missmatch got:$VER_TEST check:$TAG"
      EXIT_STATUS=255
    fi
  else
    echo "not tested"
  fi
 
}

EXIT_STATUS=0

create_container


if [ "$EXIT_STATUS" = "0" ]; then

  CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER)  

  echo -n  "Waitning for container to startup .. "

  # give it enought time to startup
  sleep 10

  echo "OK"

  test_container


  if [ ! "$EXIT_STATUS" = "0" ]; then
    echo "---- log output from container ---"
    docker logs $CONTAINER
  fi  
  delete_container 

else

  echo "FAILED to start container: $CONTAINER"
  EXIT_STATUS=1

fi

exit $EXIT_STATUS
