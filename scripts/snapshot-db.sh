#!/bin/bash

set -eou pipefail

finish() {
  code=$?
  if [ "${code}" == 0 ]; then
    rollbar.sh -s -m "Successful Snapshot created!" -r $ROLLBAR_TOKEN;
  else
    rollbar.sh -f -m "Snapshotting Failed!" -r $ROLLBAR_TOKEN;
  fi
  mysqladmin -h 127.0.0.1 -u root shutdown
  exit $code
}

while getopts h:u:p:d:b:l: option
do
case "${option}"
in
h) HOST=${OPTARG};;
u) USER=${OPTARG};;
p) PASSWORD=${OPTARG};;
d) DATABASE=$OPTARG;;
b) BUCKET=$OPTARG;;
l) BUCKETPATH=$OPTARG;;
o) PORT=$OPTARG;;
esac
done

trap finish EXIT;

echo "Take snapshot"
mysqldump --verbose --user="${USER}" --port="${PORT}" --host="${HOST}" --password="${PASSWORD}" ${DATABASE} > snapshot.dump

echo "Create db locally"
mysql -h 127.0.0.1 -u root --verbose --execute "CREATE DATABASE snapshotdb;"

echo "Import snapshot"
mysql -h 127.0.0.1 -u root snapshotdb < snapshot.dump

echo "Anonymise data"
mysql -h 127.0.0.1 -u root --verbose snapshotdb < /sqlscripts/anonymise.sql

echo "Take new dump"
mysqldump -h 127.0.0.1 -u root --verbose snapshotdb > anon.dump

FILE_NAME=prod-anon-`date -u '+%Y%m%d%H%M%S'`.sql

cp snapshot.dump ${FILE_NAME}
gzip ${FILE_NAME}
aws s3 cp ${FILE_NAME}.gz s3://${BUCKET}/${BUCKETPATH}/
