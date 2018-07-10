#!/bin/bash
set -eou pipefail

SUCCESS=false

while getopts "l:m:r:" option
do
case "${option}"
in
l) LEVEL=${OPTARG};;
m) MESSAGE=${OPTARG};;
r) TOKEN=${OPTARG};;
esac
done

if [ -z "${TOKEN}" ]; then
  echo "Missing Rollbar Token";
  exit 1;
fi

if [ -z "${MESSAGE}" ]; then
  echo "Missing Message";
  exit 1;
fi

if [ -z "${LEVEL}" ]; then
  echo "Missing Level";
  exit 1;
fi

postdata='{ "access_token" : "'${TOKEN}'", "data" : { "environment" : "production", "level" : "'${LEVEL}'", "body" : { "message" : { "body" : "'${MESSAGE}'" } } } }';

curl --verbose --request POST --url https://api.rollbar.com/api/1/item/ --data "${postdata}"
