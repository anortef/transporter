#!/usr/bin/env bash
cd /golang/src/github.com/cornerjob/transporter
echo "Getting dependencies."
/golang/bin/godep restore
cd /golang/src/github.com/cornerjob/transporter/cmd/transporter
echo "Building transporter."
go build
echo "Getting the version that has been compiled."
./transporter -v
