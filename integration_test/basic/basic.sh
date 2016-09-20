#!/usr/bin/env bash
set -e

THISDIR=$( dirname "${BASH_SOURCE[0]}" )
cd $THISDIR

if [ $(docker ps -a|grep mongo-basic-test|wc -l) == 1 ]
    then
        echo "Removing existing previous mongo for this test"
        docker rm -f mongo-basic-test
fi

if [ $(docker ps -a|grep els-basic-test|wc -l) == 1 ]
    then
        echo "Removing existing previous elastic for this test"
        docker rm -f els-basic-test
fi

echo "starting mongo on port 57017(to avoid conflicts with existing ones)"
docker run -d --name mongo-basic-test -p 0.0.0.0:57017:27017 mongo

echo "starting elastic on port 59200"
docker run -d --name els-basic-test -p 0.0.0.0:59200:9200 elasticsearch

echo "Preparing dummy data on mongodb"
docker cp base-datase.json mongo-basic-test:/base.json
docker exec -ti mongo-basic-test mongoimport --db test --collection restaurants --drop --file /base.json

echo "Compiling transporter"
cd ../../
godep restore
cd cmd/transporter
go build
echo "Builded transporter "$(./transporter -v)

cd $THISDIR
echo "Launching transporter"
chmod +x ../../cmd/transporter/transporter
../../cmd/transporter/transporter run --config config.yaml application.js
