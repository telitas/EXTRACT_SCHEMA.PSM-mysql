#!/usr/bin/env bash
set -eu

script_directory=$(cd $(dirname $0); pwd)
test_root_directory="${script_directory}"
repos_root_directory=$(cd $(dirname ${test_root_directory}); pwd)

docker compose down --volumes
docker compose up --detach

while ! mysqladmin --defaults-file="${test_root_directory%/}/cnf/root.cnf" ping > /dev/null 2> /dev/null
do
    echo -n .
    sleep 1
done
echo

mysql --defaults-file="${test_root_directory%/}/cnf/root.cnf" --database=mydb --silent --execute "SET GLOBAL log_bin_trust_function_creators=1;"
