#!/bin/sh

set -euo pipefail

files=(
	assets/images/sleep-orig/*
)
for source in ${files[@]}; do
	dest=$source
	dest=${dest//sleep-orig/sleep}
	dest=${dest%.*}
	echo "$source -> $dest"
	if [[ "$source" =~ "roles-in-society" ]] || [[ "$source" =~ "my-sleep-pledge" ]]; then
		cp $source $dest.gif
		continue
	fi
	convert \
		$source \
		-format webp \
		-resize 720x\> \
		-quality 45 \
		$dest.webp
done
