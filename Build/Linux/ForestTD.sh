#!/bin/sh
echo -ne '\033c\033]0;TD\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/ForestTD.x86_64" "$@"
