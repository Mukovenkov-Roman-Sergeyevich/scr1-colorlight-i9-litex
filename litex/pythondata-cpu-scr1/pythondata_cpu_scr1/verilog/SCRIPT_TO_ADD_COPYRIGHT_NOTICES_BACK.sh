#!/bin/bash

copyright_notice='/// Copyright by Syntacore LLC © 2016-2021. See LICENSE for details'

find . -type f -name "*.v" | while read -r file; do
    if grep -qF "$copyright_notice" "$file"; then
        echo "Notice present in $file, skip"
    else
        temp_file=$(mktemp)
        echo "$copyright_notice" | cat - "$file" > "$temp_file"
        mv "$temp_file" "$file"
        echo "Updated copyright notice in $file"
    fi
done
