#!/usr/bin/env bash

TODAY=`date +%Y-%m-%d-%H-%M-%S`
ENVIRONMENT=prod
SERVER=quotr.ca

if [ "$#" -eq 1 ];
then
    ENVIRONMENT=$1
fi

HOST_KEY=quotr-server.pem
if [ "$ENVIRONMENT" == "test" ];
then
    HOST_KEY=test-server.pem
    SERVER=spottingquotes.ca
fi

PATH_TO_KEY=$PATH_TO_HOSTING$HOST_KEY
LOG_DIR="~/tmp/logs/$TODAY"
OUT_DIR="$HOME/tmp/$ENVIRONMENT/$TODAY/"
TAR_NAME="$TODAY.tar.gz"
TAR_LOCATION="$LOG_DIR/$TAR_NAME"

echo "TODAY: " $TODAY
echo "ENVIRONMENT: " $ENVIRONMENT
echo "SERVER: " $SERVER
echo "OUT_DIR: " $OUT_DIR
echo "PATH_TO_HOSTING: " $PATH_TO_HOSTING
echo "PATH_TO_KEY: " $PATH_TO_KEY
echo "LOG_DIR: " $LOG_DIR
echo "TAR_LOCATION: " $TAR_LOCATION

echo "creating $OUT_DIR"
mkdir -p $OUT_DIR

echo "copying logs to $LOG_DIR"
ssh -i $PATH_TO_KEY quotr@$SERVER "mkdir -p $LOG_DIR && sudo cp /var/log/mail* $LOG_DIR && sudo cp ~/app/current/log/* $LOG_DIR"

echo "taring logs in $LOG_DIR"
ssh -i $PATH_TO_KEY quotr@$SERVER "cd $LOG_DIR && sudo tar czvf $TAR_NAME *"

echo "downloading"
scp -i $PATH_TO_KEY quotr@$SERVER:$TAR_LOCATION $OUT_DIR

echo "extracting $OUT_DIR$TAR_NAME"
cd $OUT_DIR
tar -zxvf $TAR_NAME