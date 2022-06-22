#!/bin/bash

set -e

SRC_DIR="${1:?'Please provide a source directory'}"
DST_DIR="${2:?'Please provide a destination directory'}"

function get_ext {
	declare -r file="${1:?'Please provide a file'}"

	[[ "$file" = *.* ]] && echo ".${file##*.}" || echo ''
}

find -L "$SRC_DIR/" -type f -not -xtype f -print0 | while IFS= read -r -d $'\0' file; do
	file_name="$(basename "$file")"
	ext="$(get_ext "$file_name")"
	dir="$(dirname "$file")/"
	dst_dir="$DST_DIR/${dir#"$SRC_DIR/"}"

	mkdir -p "$dst_dir"

	if [ "$ext" = ".template" ]; then
		dst="$dst_dir/${file_name%.*}"
		echo "running envsubst '$file' --> '$dst'"
		envsubst < "$file" > "$dst"
	else
		dst="$dst_dir/$file_name"
		echo "copying file '$file' --> '$dst'"
		cp "$file" "$dst"
	fi
done
