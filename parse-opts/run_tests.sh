#!/bin/bash

G_TMP_FILE="tmp_result.txt"
G_BINARY=""

function run_write
{
    local LOC_TCASE="$1"
    $G_BINARY $LOC_TCASE > $G_TMP_FILE 2>&1
}

function run_append
{
    local LOC_TCASE="$1"
    $G_BINARY $LOC_TCASE >> $G_TMP_FILE 2>&1
}

function file_compare
{
    local LOC_TFILE="$1"
    local LOC_TCASE="$2"

    diff $G_TMP_FILE $LOC_TFILE
    if [ $? -ne 0 ]; then
        echo "Failed test case:" $LOC_TCASE
        echo "Result with file" $LOC_TFILE "differ"
        exit 1
    fi
}

function test_run_compare
{
    local LOC_TCASE="$1"
    local LOC_TFILE="$2"
    run_write "$LOC_TCASE"
    file_compare "$LOC_TFILE" "$LOC_TCASE"
}

function run_tests
{
    TEST_DIR="./tests"

    TEST_FILE="$TEST_DIR/short_names.txt"
    TEST_CASE="-i -j -k -kji -jkia123 -jkia 123 -akji -ks1,2,3"
    test_run_compare "$TEST_CASE" "$TEST_FILE"

    TEST_FILE="$TEST_DIR/long_names.txt"
    TEST_CASE="--i-flag --a-option a,b,c --sub-args a,b,c"
    test_run_compare "$TEST_CASE" "$TEST_FILE"

    TEST_FILE="$TEST_DIR/requires_arg_err.txt"
    run_write "-a"
    run_append "--a-option"
    run_append "--a-option="
    file_compare $TEST_FILE "-a, then --a-option, then --a-option="

    TEST_FILE="$TEST_DIR/flag_no_arg_err.txt"
    TEST_CASE="-ibcd -i bcd --i-flag bcd"
    run_write "$TEST_CASE"
    run_append "--i-flag=bcd"
    run_append "--i-flag="
    file_compare $TEST_FILE "$TEST_CASE, then --i-flag=bcd, then --i-flag="

    TEST_FILE="$TEST_DIR/args_sub_args.txt"
    TEST_CASE="-sa,b,c -s,,,,a,,b,c,,, --sub-args=a,b,c --sub-args=,,a,,b,,,c,,,,
    --sub-args a,b,c --sub-args ,,a,,,b,,,c, -sa --sub-args=a --sub-args a
    --sub-args= ,a,,,b,,,c --sub-args= a,b,c -aa,b,c  --a-option=a,b,c
    --a-option= a,b,c --a-option a,b,c"
    test_run_compare "$TEST_CASE" "$TEST_FILE"

    TEST_FILE="$TEST_DIR/no_opt_args_dash_and_all_is_arg.txt"
    TEST_CASE="-ij one -k two three -a123 - -- -a123 --sub-args"
    test_run_compare "$TEST_CASE" "$TEST_FILE"

    TEST_FILE="$TEST_DIR/unknown_opt_and_help.txt"
    TEST_CASE="-ijzmk --a-option 123 --random --help -z -h"
    test_run_compare "$TEST_CASE" "$TEST_FILE"
}

function clean_up
{
    rm $G_TMP_FILE
}

function main
{
    if [ "$#" -ne 1 ]; then
        echo "Use: $0 <path-to-opts-test-binary>"
        exit 1
    fi

    G_BINARY="$1"
    
    if [ ! -f "$G_BINARY" ]; then
		echo "error: $G_BINARY is not a file"
		exit 1
    fi
    
    run_tests
    clean_up
}

main "$@"
