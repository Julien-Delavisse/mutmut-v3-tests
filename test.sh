#!/bin/bash

set -eu

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

results_logs_location=results.log

result_save()
{
    echo ""
    if [ $2 -eq 0 ]; then
        echo -e [${GREEN}SUCCESS${NC}] $1 | tee -a $results_logs_location
    else
        echo -e [${RED}FAILED ${NC}] $1 | tee -a $results_logs_location
    fi
}

echo "" > $results_logs_location

while read python_version mutmut_version; do
    image_tag=$python_version"-"$mutmut_version
    echo $image_tag
    PYTHON_VERSION=$python_version MUTMUT_VERSION=$mutmut_version docker build --quiet --build-arg PYTHON_VERSION=$python_version --build-arg MUTMUT_VERSION=$mutmut_version -t mutmut_test:$image_tag . || continue
    docker run mutmut_test:$image_tag && result=0 || result=1
    result_save $image_tag $result
done < <(tail -n +1 combinaisons.txt)
