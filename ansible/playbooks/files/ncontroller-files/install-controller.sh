#!/bin/bash

./install.sh \
    -d 10.1.20.20 \
    -k 5432 \
    -r n-controller \
    -s Default1234! \
    -m localhost\
    -x 25 \
    -b false \
    -g false \
    -j no-reply@f5-udf.com \
    -e admin@f5-udf.com \
    -p Default1234! \
    -f 10.1.20.70 \
    --tsdb-volume-type local \
    -a f5-udf \
    -t f5-udf \
    -u Administrator \
    -y \
    -c

