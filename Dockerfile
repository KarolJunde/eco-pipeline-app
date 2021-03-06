FROM node:9.3-alpine

ADD package*.json /tmp/
RUN cd /tmp && npm install
RUN mkdir -p /opt/dynamodb-backup-restore && cp -a /tmp/node_modules /opt/dynamodb-backup-restore/

WORKDIR /opt/dynamodb-backup-restore
ADD . /opt/dynamodb-backup-restore
RUN ["chmod", "+x", "/opt/dynamodb-backup-restore/bin/dynamo-restore-from-s3"]

ENV TABLE_NAME ProductRestore
ENV RCU 5
ENV WCU 5
ENV S3_JSON_FILE s3://nexiot-sandbox-backup/DynamoDB-backup-2017-12-15-19-18-12/Products.json
ENV CONCURRENCY_LEVEL 1000
ENV REGION eu-central-1
CMD cd /opt/dynamodb-backup-restore && ./bin/dynamo-restore-from-s3 -t $TABLE_NAME -c $CONCURRENCY_LEVEL -s $S3_JSON_FILE --readcapacity $RCU --writecapacity $WCU --aws-region $REGION