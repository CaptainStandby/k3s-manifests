#!/bin/bash

set -ex

SRC_DIR="${1:?'Please provide a source directory'}"
DST_DIR="${2:?'Please provide a destination directory'}"

function get_ext {
	declare -r file="${1:?'Please provide a file'}"

	[[ "$file" = *.* ]] && echo ".${file##*.}" || echo ''
}

find "$SRC_DIR/" -type f -print0 | while IFS= read -r -d $'\0' file; do
	file_name="$(basename "$file")"
	ext="$(get_ext "$file_name")"
	dir="$(dirname "$file")/"
	dst_dir="$DST_DIR/${dir#"$SRC_DIR/"}"

	mkdir -p "$dst_dir"

	if [ "$ext" = ".template" ]; then
		file_no_ext="${file_name%.*}"
		envsubst < "$file" > "$dst_dir/$file_no_ext"
	else
		cp -v "$file" "$dst_dir/$file_name"
	fi
done
