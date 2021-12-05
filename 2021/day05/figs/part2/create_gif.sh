#!/bin/bash

folders=( "sample" "input" )
frames=( 1 25 )
for i in {0..1}; do
  ffmpeg -y -i ${folders[${i}]}/output%03d.png -vf palettegen ${folders[${i}]}/palette.png
  ffmpeg -y -framerate ${frames[${i}]} -i ${folders[${i}]}/output%03d.png -f image2 -i ${folders[${i}]}/palette.png -filter_complex \
    "[0:v] fps=${frames[${i}]},scale=-1:-1:flags=full_chroma_int,split [a][b];[a] palettegen=max_colors=255:reserve_transparent=1:stats_mode=diff [p];[b][p] paletteuse=dither=none:bayer_scale=5:diff_mode=rectangle:new=1:alpha_threshold=128" \
    -gifflags -offsetting -y ${folders[${i}]}.gif
done


