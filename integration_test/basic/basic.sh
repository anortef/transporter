#!/usr/bin/env bash
set -e

THISDIR="$(cd "$(dirname "$0")" && pwd)"
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

echo "We wait a couple of seconds to let everything start..."
sleep 5

echo "Preparing dummy data on mongodb"
docker cp base-dataset.json mongo-basic-test:/base.json
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
../../cmd/transporter/transporter run --config $THISDIR/config.yaml $THISDIR/application.js
sleep 5

echo "Getting restaurant_id 40361322 to compare"
FROMELS="$(curl -s -XGET "http://localhost:59200/test/_search?q=restaurant_id:40361322" | python -c "import sys, json; print json.dumps(json.load(sys.stdin)['hits']['hits'][0]['_source'])")"
echo "Comparing it from the expected"
FROMEXP="$(cat expected_output)"
if test "$FROMELS" = "$FROMEXP"; then
  echo "Transformer OK"
  echo "Cleaning up the dockers"
  docker rm -f mongo-basic-test els-basic-test
  exit 0
else
  echo "Something went wrong"
  echo "----------GOT---------------"
  echo $FROMELS
  echo "----------------------------"
  echo "-----------EXPECTED---------"
  echo $FROMEXP
  echo "----------------------------"
  exit 1
fi
