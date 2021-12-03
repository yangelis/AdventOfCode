reset
!set terminal qt persist
set terminal png size 1366, 768 background '#00333333'
set output 'figs/day02_plots.png'
set size 1,1

set grid
set xlabel 'x' textcolor rgb "white"
set ylabel 'y' textcolor rgb "white"

set border 31 linecolor "white"

set xrange[0:2200]

set key left top opaque fillcolor "grey"

set multiplot layout 1, 2 columnsfirst
set title "Part1" textcolor "white"
set yrange[0:1200]
plot "coords.txt" ps 0.2 pt 6 lc '#004682b4' notitle, \
keyentry with points pt 6 lt 1 lc '#004682b4' title "Position"
set title "Part2" textcolor "white"
scale = 0.015
set yrange[*:*]
plot "coords2.txt" using 1:2:(($3)*scale) ps variable pt 6 lt 1 lc '#004682b4' notitle, \
keyentry with points pt 6 lt 1 lc '#004682b4' title "Aim Radius", \
"coords2.txt" using 1:2 ps 0.2 pt 7 lc '#00ffff22' notitle, \
keyentry with points pt 7 lc '#00ffff22' title "Position"
unset multiplot

