#!/usr/bin/env bash
set -eu

script_directory=$(cd $(dirname $0); pwd)
test_root_directory=$(cd $(dirname ${script_directory}); pwd)
output_directory="${script_directory}/schema"

if [[ ! -e $output_directory ]]; then
    mkdir -p $output_directory
fi

for file in `ls ${test_root_directory%/}/initdb/*_mydb_*.sql`
do
    table_name=$(echo $(basename $file) | sed -E "s/^[0-9]+_mydb_([^.]+).sql$/\1/g")
    mysql --defaults-file="${test_root_directory%/}/cnf/myuser.cnf" --database=mydb --silent --raw --skip-column-names --execute "SELECT extract_table_as_json_in_current_schema('$table_name');" \
    | jq > "${output_directory%/}/${table_name}.json"
done;
