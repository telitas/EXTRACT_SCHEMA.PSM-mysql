#!/usr/bin/env bats

setup() {
    cd $BATS_TEST_DIRNAME
}

# sample_table

@test "sample_table.json validate no_records.json -> valid" {
    npx ajv validate -s ./schema/sample_table.json -d ./data/sample_table/valid/no_records.json -c ajv-formats --spec=draft2019
}

@test "sample_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/sample_table.json -d ./data/sample_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

# all_types_table

@test "all_types_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "all_types_table.json validate timestamp_with_time_zone_without_time_zone.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/invalid/timestamp_with_time_zone_without_time_zone.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "all_types_table.json validate timestamp_without_time_zone_with_time_zone.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/invalid/timestamp_without_time_zone_with_time_zone.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "all_types_table.json validate time_is_839h.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/invalid/time_is_839h.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "all_types_table.json validate time_is_840h.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/invalid/time_is_840h.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "all_types_table.json validate time_is_900h.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/all_types_table.json -d ./data/all_types_table/invalid/time_is_900h.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

# notnull_table

@test "notnull_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/notnull_table.json -d ./data/notnull_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "notnull_table.json validate null_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/notnull_table.json -d ./data/notnull_table/invalid/null_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "notnull_table.json validate omit_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/notnull_table.json -d ./data/notnull_table/invalid/omit_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

# single_column_key_table

@test "single_column_key_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/single_column_key_table.json -d ./data/single_column_key_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "single_column_key_table.json validate duplicate_rows.json -> valid" {
    npx ajv validate -s ./schema/single_column_key_table.json -d ./data/single_column_key_table/valid/duplicate_rows.json -c ajv-formats --spec=draft2019
}

@test "single_column_key_table.json validate null_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/single_column_key_table.json -d ./data/single_column_key_table/invalid/null_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "single_column_key_table.json validate omit_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/single_column_key_table.json -d ./data/single_column_key_table/invalid/omit_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

# multiple_columns_key_table

@test "multiple_columns_key_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/multiple_columns_key_table.json -d ./data/multiple_columns_key_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "multiple_columns_key_table.json validate duplicate_rows.json -> valid" {
    npx ajv validate -s ./schema/multiple_columns_key_table.json -d ./data/multiple_columns_key_table/valid/duplicate_rows.json -c ajv-formats --spec=draft2019
}

@test "multiple_columns_key_table.json validate null_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/multiple_columns_key_table.json -d ./data/multiple_columns_key_table/invalid/null_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "multiple_columns_key_table.json validate omit_column.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/multiple_columns_key_table.json -d ./data/multiple_columns_key_table/invalid/omit_column.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

# single_column_unique_table

@test "single_column_unique_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/single_column_unique_table.json -d ./data/single_column_unique_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "single_column_unique_table.json validate duplicate_rows.json -> valid" {
    npx ajv validate -s ./schema/single_column_unique_table.json -d ./data/single_column_unique_table/valid/duplicate_rows.json -c ajv-formats --spec=draft2019
}

# multiple_columns_unique_table

@test "multiple_columns_unique_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/multiple_columns_unique_table.json -d ./data/multiple_columns_unique_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "multiple_columns_unique_table.json validate duplicate_rows.json -> valid" {
    npx ajv validate -s ./schema/multiple_columns_unique_table.json -d ./data/multiple_columns_unique_table/valid/duplicate_rows.json -c ajv-formats --spec=draft2019
}

# numeric_scale_table

@test "numeric_scale_table.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

@test "numeric_scale_table.json validate no_scale_empty.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/no_scale_empty.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate no_scale_point_only.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/no_scale_point_only.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate no_scale_too_long_fraction.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/no_scale_too_long_fraction.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate no_scale_too_long_integer.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/no_scale_too_long_integer.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate one_scale_empty.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/one_scale_empty.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate one_scale_point_only.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/one_scale_point_only.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate one_scale_too_long_fraction.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/one_scale_too_long_fraction.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate one_scale_too_long_integer.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/one_scale_too_long_integer.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate two_scale_empty.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/two_scale_empty.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate two_scale_point_only.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/two_scale_point_only.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate two_scale_too_long_fraction.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/two_scale_too_long_fraction.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

@test "numeric_scale_table.json validate two_scale_too_long_integer.json -> invalid" {
    set +e
    npx ajv validate -s ./schema/numeric_scale_table.json -d ./data/numeric_scale_table/invalid/two_scale_too_long_integer.json -c ajv-formats --spec=draft2019
    result=$?
    set -e
    [ $result -ne 0 ]
}

# sample_view

@test "sample_view.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/sample_view.json -d ./data/sample_table/valid/valid_values.json -c ajv-formats --spec=draft2019
}

# literal_view

@test "literal_view.json validate valid_values.json -> valid" {
    npx ajv validate -s ./schema/literal_view.json -d ./data/literal_view/valid/valid_values.json -c ajv-formats --spec=draft2019
}
