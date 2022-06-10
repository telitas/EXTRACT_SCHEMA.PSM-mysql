#!/usr/bin/env bats

setup() {
    cd $BATS_TEST_DIRNAME
}

@test "schema.json validate all extract schema -> valid" {
    for filepath in `find ./schema/ -name "*.json"`
    do
        npx ajv validate -s ./schema.json -d $filepath -c ajv-formats --spec=draft2019
    done
}
