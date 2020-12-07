#!/bin/bash

function main
{
	pushd "$(dirname $(realpath $0))" > /dev/null
	
	
	local L_DIR="./parse-opts-code-generator"
	AWKPATH="$L_DIR" awk -f "$L_DIR/parse-opts-gen.awk" "$L_DIR/opts-gen.txt" | \
	awk '
		/<opts_definitions>/,/<\/opts_definitions>/ {
			print  $0 > "opts_definitions.ic"
		}
		
		/<opts_process>/,/<\/opts_process>/ {
			print $0 > "opts_process.ic"
		}
	'
	
	popd > /dev/null
}

main
