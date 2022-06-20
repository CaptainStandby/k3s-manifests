#!/bin/bash

set -e

find "." -maxdepth 1 -type f -name '*.env' -print0 | while IFS= read -r -d $'\0' file; do
	file_no_ext="$(basename "$file" .env)"

	secret="$(kubectl create secret generic \
		"$file_no_ext" \
		--dry-run=client \
		--show-managed-fields=false \
		-o yaml \
		--from-env-file <(sops -d "$file"))"

	echo "$secret" | kubeseal \
		-n "openhab" \
		--scope namespace-wide \
		-o yaml -w "$file_no_ext.yaml"
done

