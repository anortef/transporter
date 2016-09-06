#!/usr/bin/env bash
docker build -t transporter-builder .
docker run --name=transporter-builder -v "$(dirname "$(realpath "$0")")":/golang/src/github.com/cornerjob/transporter transporter-builder
docker rm transporter-builder
