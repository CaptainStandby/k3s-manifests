#!/bin/bash

set -e

function seal_secrets {
	declare -r input_file="${1:?'Please provide a file'}"
	declare -r namespace="${2:?'Please provide a namespace'}"
	declare -r cert_file="${3:?'Please provide a certificate file'}"
	declare -r directory="$(dirname "$input_file")"
	declare -r file_no_ext="$(basename "$input_file" .env)"
	
	declare -r secret="$(kubectl create secret generic \
		"$file_no_ext" \
		--dry-run=client \
		--show-managed-fields=false \
		-o yaml \
		--from-env-file <(sops -d "$input_file"))"

	echo "$secret" | kubeseal \
		-n "$namespace" \
		--scope namespace-wide \
		--cert "$cert_file" \
		-o yaml -w "$directory/$file_no_ext.yaml"
}

seal_secrets "$@"
