#!/bin/bash

# This script will kill the process running on port 8080 if it exists and then do other things

PID=$(lsof -t -i:8080)
if [ -z "$PID" ]
then
    echo "No PID found"
else
    echo "Killing PID $PID"
    kill $PID
fi

yarn build
nohup ./aws-lambda-rie yarn aws-lambda-ric dist/index.handler > /dev/null 2>&1 &
yarn test