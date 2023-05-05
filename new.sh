#!/bin/bash

OJ=$1

if [[ "$1" == "" ]]; then
    echo "Usage: $0 <OJ>"
    echo "  Supported OJ: leetcode"
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
fi

hexo new $OJ $PID > /dev/null
mv "./source/_posts/$PID.md" "./source/_posts/$OJ/$PID.md"

TARGET="./source/_posts/$OJ/$PID.md"

sed -i "s/PNAME/$PNAME/" $TARGET
sed -i "s/CATEGORY/\[解題區, Leetcode, $DIFF\]/" $TARGET

echo "Created: $TARGET"