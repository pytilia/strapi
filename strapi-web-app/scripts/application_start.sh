#!/bin/bash

# Deploy hooks are run via absolute path, so taking dirname of this script will give us the path to
# our deploy_hooks directory.
. $(dirname $0)/common_variables.sh

# After 60 seconds the loop will exit
timeout=60

echo "Ensuring nginx dir exists ..."
while [ ! -f /etc/nginx/nginx.conf ];
do
  # When the timeout is equal to zero, show an error and leave the loop.
  if [ "$timeout" == 0 ]; then
    echo "ERROR: Timeout while waiting for the file /etc/nginx/nginx.conf."
    #exit 1
  fi

  echo "#"
  sleep 1

  # Decrease the timeout of one
  ((timeout--))
done

sudo mv $DESTINATION_PATH/scripts/nginx.conf /etc/nginx/nginx.conf


sudo service nginx restart
env >$DESTINATION_PATH/env.log
cd $DESTINATION_PATH/strapi-web-app
npm run develop > $DESTINATION_PATH/app.log 2>&1 &
exit