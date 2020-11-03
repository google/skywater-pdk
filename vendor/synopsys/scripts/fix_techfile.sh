#!/bin/bash
# Adding Missing fildpoly and diff layer in technology file
AddLayers="Layer		\"fieldpoly\" { \\n \
		layerNumber			= 14 \\n\
		maskName			= \"poly\" \\n\
		isDefaultLayer		= 1 \\n\
		visible				= 1 \\n\
		selectable			= 1 \\n\
		blink				= 0 \\n\
		color				= \"red\" \\n\
		lineStyle			= \"solid\" \\n\
		pattern				= \"dot\" \\n\
		pitch				= 0.46 \\n\
		defaultWidth		= 0.14 \\n\
		minWidth			= 0.14 \\n\
		minSpacing			= 0.14 \\n\
} \\n\
\\n\
\\n\
Layer		\"diff\" { \\n\
		layerNumber			= 15 \\n\
		maskName			= \"diffusion\" \\n\
		isDefaultLayer		= 1 \\n\
		visible				= 1 \\n\
		selectable			= 1 \\n\
		blink				= 0 \\n\
		color				= \"40\" \\n\
		lineStyle			= \"dash\" \\n\
		pattern				= \"dot\" \\n\
		pitch				= 0 \\n\
}\\n"

Layers=$(grep "^Layer" $1 | wc -l)
[[ "$Layers" -ne 13 ]] && echp "x x x x x x Number of layers are not 13 x x x x x x" && exit 0
echo "Found 13 Layers"
InsertLine=$(grep -n "^ContactCode" $1 | head -n 1 | grep -Eo '^[^:]+')
# sed -i "${InsertLine}i${AddLayers}" $1
