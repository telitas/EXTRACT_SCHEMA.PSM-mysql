#!/usr/bin/env bash
set -u

while getopts t:h OPT
do
    case $OPT in
        t)  mysql_test_directory=$OPTARG
            ;;
        h)  echo "Usage: $0 [-t <mysql test directory>]" 1>&2; exit
            ;;
    esac
done

echo "Start database"
./reset-database.sh

echo "JSON test"
./json/function-test.sh -t ${mysql_test_directory}
if [[ $? -ne 0 ]]; then
    exit 1
fi
./json/extract-schema.sh
./json/schema.test.bats
if [[ $? -ne 0 ]]; then
    exit 2
fi
./json/data.test.bats
if [[ $? -ne 0 ]]; then
    exit 3
fi


