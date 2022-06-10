#!/usr/bin/env bash
set -eu

script_directory=$(cd $(dirname $0); pwd)
repos_root_directory=$script_directory

tag_name=`git tag -l --points-at HEAD`
if [[ -z "$tag_name" ]]; then
    echo "There is no tag in current commit."
    exit 1
fi

package_name="$(basename $repos_root_directory)-${tag_name}"
output_directory="${repos_root_directory%/}/${package_name}"
if [[ -d $output_directory ]]; then
    rm -rf $output_directory
fi
mkdir $output_directory

cd $repos_root_directory
for file in ./src/*.sql
do
    last_update_date=`git log --max-count 1 --pretty=format:"%cs" ${file}`
    cat $file \
    | sed "s/\${version}/${tag_name}/g" \
    | sed "s/\${last_update}/${last_update_date}/g" \
    > "${output_directory}/$(basename $file)"
done;

archive_name="${package_name}.zip"
if [[ -e $archive_name ]]; then
    rm $archive_name
fi
zip -rm $archive_name "./$(basename $output_directory)" >> /dev/null
