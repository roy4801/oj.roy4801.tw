#!/bin/bash

OJ=$1

if [[ "$1" == "" ]]; then
    echo "Usage: $0 <OJ>"
    echo "  Supported OJ: leetcode"
    exit 1
fi

if [[ "$OJ" == "leetcode" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: $0 leetcode <problem ID>"
        exit 1
    fi
    PID=$2
fi

git add source/_posts/leetcode/$PID.md
git commit -m "leetcode: $PID"
git pull
git push
