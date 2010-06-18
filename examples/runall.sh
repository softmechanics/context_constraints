#!/bin/bash

cd "$(dirname $0)"
find -name '*.hs' -exec ./run.sh $1 {} \;
