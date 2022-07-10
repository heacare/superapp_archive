#!/bin/sh

set -euo pipefail

#naga assets/gradient.wgsl assets/gradient_tmp.spv
#spirv-dis assets/gradient_tmp.spv \
#	| sed 's/OriginUpperLeft/OriginLowerLeft/g' \
#	| spirv-as -o assets/gradient.spv
#rm assets/gradient_tmp.spv

echo Transpiling wgsl
naga \
	--profile es310 \
	--entry-point fs_main \
	assets/gradient.wgsl \
	assets/gradient.frag

sed -i -r \
	's/uniform .+ \{ (.+) \};/layout(location = 0) uniform \1/' \
	assets/gradient.frag

echo Compiling frag
glslc \
	--target-env=opengl \
	-fauto-bind-uniforms \
	-o assets/gradient.spv \
	assets/gradient.frag

echo Generated: $(date)
