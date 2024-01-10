#!/bin/bash

# set -xe

leetcode_info=()
function get_leetcode_info() {
	pid=$1
	difficulty=("Easy" "Medium" "Hard")
	problem_set=`curl -sS https://leetcode.com/api/problems/algorithms/`
	#problem=`echo $problem_set | jq '.stat_status_pairs[].stat | select( .frontend_question_id == 3)'`
	problem=`echo $problem_set | jq ".stat_status_pairs[] | select( .stat.frontend_question_id == $pid )"`
	
	#echo $problem
	
	leetcode_info=()
    # 0 = problem id
    # 1 = difficulty
    # 2 = problem title
    # 3 = url
	leetcode_info+=("$pid")
	leetcode_info+=("${difficulty[`echo $problem | jq '.difficulty.level'`]}")
	leetcode_info+=("`echo $problem | jq '.stat.question__title'`")

	question_title_slug=`echo $problem | jq '.stat.question__title_slug'`
	question_title_slug=${question_title_slug//\"/}
	leetcode_info+=("https://leetcode.com/problems/${question_title_slug}")
}

function usage() {
    echo "Usage: $0 <OJ>"
    echo "  Supported OJ: leetcode cses"
    exit 1
}

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SED_PARAM=-i
elif [[ "$OSTYPE" == "darwin"* ]]; then
    SED_PARAM=-i ''
elif [[ "$OSTYPE" == "cygwin" ]]; then
    SED_PARAM=-i
elif [[ "$OSTYPE" == "msys" ]]; then
    SED_PARAM=-i
elif [[ "$OSTYPE" == "win32" ]]; then
    echo win32
else
    echo Unsupported 
fi

OJ=$1

if [[ "$1" == "" ]]; then
    usage
fi

if [[ "$OJ" == "leetcode" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: $0 leetcode <problem ID> <problem name> <difficulty>"
        exit 1
    fi
    PID=$2
    PNAME="$3"
    DIFF="$4" # For leetcode

    if [[ "${PNAME}" == "" ]]; then
        get_leetcode_info $PID
        PNAME=${leetcode_info[2]//\"/}
        DIFF=${leetcode_info[1]}
        URL="${leetcode_info[3]}"
    fi
elif [[ "$OJ" == "cses" ]]; then
    if [[ "$2" == "" ]]; then
        echo "Usage: $0 cses <problem ID> <problem name> <category>"
        exit 1
    fi
    PID=$2
    PNAME="$3"
    CAT="$4" # For cses
else
    usage
fi

hexo new $OJ $PID > /dev/null
mv "./source/_posts/$PID.md" "./source/_posts/$OJ/$PID.md"

TARGET="./source/_posts/$OJ/$PID.md"

sed ${SED_PARAM} "s/PNAME/$PNAME/" $TARGET

if [[ "$OJ" == "leetcode" ]]; then
    sed ${SED_PARAM} "s/CATEGORY/\[解題區\, Leetcode\, $DIFF\]/" $TARGET
    sed ${SED_PARAM} "s|\[題目\]()|\[題目\]($URL)|g" $TARGET
elif [[ "$OJ" == "cses" ]]; then
    sed ${SED_PARAM} "s/CATEGORY/\[解題區\, CSES\, $CAT\]/" $TARGET
fi

echo "Created: $TARGET"
