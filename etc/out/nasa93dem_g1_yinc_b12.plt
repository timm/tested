set yrange [0 : 100]
set key top left
set xlabel "truth"
set ylabel "guess"
#set terminal pdf color
set terminal pdf color font "cmr,10" size 3.5in,2.4in
set title "data=nasa93dem, gap=1,  y=inc, b=12"
set arrow 1 from graph 0,0 to 12,100 nohead
set output       "nasa93dem_g1_yinc_b12.pdf
plot for [i=1:*] "nasa93dem_g1_yinc_b12.dat" using 0:i with lines title 'run '.i
