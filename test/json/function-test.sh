#!/usr/bin/env bash
set -eu

script_directory=$(cd $(dirname $0); pwd)
test_root_directory=$(cd $(dirname ${script_directory}); pwd)
repos_root_directory=$(cd $(dirname ${test_root_directory}); pwd)

while getopts t:h OPT
do
    case $OPT in
        t)  mysql_test_directory=$OPTARG
            ;;
        h)  echo "Usage: $0 [-t <mysql test directory>]" 1>&2; exit
            ;;
    esac
done

if [[ -z $mysql_test_directory ]]; then
    echo "-t <mysql test directory> is empty."
    exit 1
elif [[ ! -x "${mysql_test_directory%/}/mysql-test-run" ]]; then
    echo "${mysql_test_directory} is not mysql-test directory."
    exit 2
fi

suite_name=EXTRACT_SCHEMA.PSM-json
if [[ ! -e "${mysql_test_directory%/}/suite/${suite_name}" ]]; then
    ln -s "${script_directory%/}/suite" "${mysql_test_directory%/}/suite/${suite_name}"
fi

mysql --defaults-file="${test_root_directory%/}/cnf/myuser.cnf" --database=mydb --silent < "${repos_root_directory%/}/src/extract_table_as_json.sql"

cd $mysql_test_directory

./mysql-test-run --defaults-file "${test_root_directory%/}/cnf/myuser.cnf" --suite $suite_name

exit $?
