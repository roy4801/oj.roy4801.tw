#!/bin/bash

OJ=$1

if [[ "$1" == "" ]]; then
    echo "Usage: $0 <OJ>"
    echo "  Supported OJ: leetcode cses"
    exit 1
fi

if [[ "$OJ" == "leetcode" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: $0 leetcode <problem ID> <problem name> <difficulty>"
        exit 1
    fi
    PID=$2
    PNAME="$3"
    DIFF="$4" # For leetcode
elif [[ "$OJ" == "cses" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: $0 cses <problem ID> <problem name> <category>"
        exit 1
    fi
    PID=$2
    PNAME="$3"
    CAT="$4" # For cses
fi

hexo new $OJ $PID > /dev/null
mv "./source/_posts/$PID.md" "./source/_posts/$OJ/$PID.md"

TARGET="./source/_posts/$OJ/$PID.md"

sed -i "s/PNAME/$PNAME/" $TARGET

if [[ "$OJ" == "leetcode" ]]; then
    sed -i "s/CATEGORY/\[解題區, Leetcode, $DIFF\]/" $TARGET
elif [[ "$OJ" == "cses" ]]; then
    sed -i "s/CATEGORY/\[解題區, CSES, $CAT\]/" $TARGET
fi

echo "Created: $TARGET"