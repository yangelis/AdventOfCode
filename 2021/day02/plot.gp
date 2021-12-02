reset 
!set terminal qt persist
set terminal png size 1366, 768
set output 'coords.png'
set size 1,1

set grid
set xlabel 'x'
set ylabel 'y'

set xrange[0:2500]



set multiplot layout 1, 2 columnsfirst
set title "Part1"
set yrange[0:1500]
plot "coords.txt" ps 1 pt 2 notitle
set title "Part2"
scale = 0.002
set yrange[*:*]
plot "coords2.txt" using 1:2:(($3)*scale) ps variable pt 7 notitle
unset multiplot

