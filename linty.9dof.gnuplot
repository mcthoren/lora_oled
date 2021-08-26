set xtics 7200 rotate by 30 offset -5.7, -2.2
set ytics
set mytics
set y2tics
set key outside below
set xlabel "Time (UTC)" offset 0.0, -1.6
set xdata time;
set format x "%F\n%TZ"
set timefmt "%Y-%m-%dT%H:%M:%SZ"
set grid xtics
set grid y2tics
set term pngcairo size 2000, 512 font ",10"

set format y "%.2f"
set format y2 "%.2f"

accel_dat_f='/home/ghz/9dof/data/accel.dat.2-3_day'
gyro_dat_f='/home/ghz/9dof/data/gyro.dat.2-3_day'
mag_dat_f='/home/ghz/9dof/data/mag.dat.2-3_day'
out_d='/home/ghz/9dof/plots/'

set title "Accelerometer Data over the Last \\~48 Hours"
set ylabel "Acceleration (m/s^2)"
set y2label "Acceleration (m/s^2)"
set output out_d.'accel_x.png'
plot accel_dat_f using 1:3 title 'Acceleration' with points linecolor rgb "#00aa00", \
accel_dat_f using 1:3 title 'Acceleration' with lines lw 2 linecolor rgb "#00ff00" smooth bezier
set output out_d.'accel_y.png'
plot accel_dat_f using 1:6 title 'Acceleration' with points linecolor rgb "#aa0000", \
accel_dat_f using 1:6 title 'Acceleration' with lines lw 2 linecolor rgb "#ff0000" smooth bezier
set output out_d.'accel_z.png'
plot accel_dat_f using 1:9 title 'Acceleration' with points linecolor rgb "#0000aa", \
accel_dat_f using 1:9 title 'Acceleration' with lines lw 2 linecolor rgb "#0000ff" smooth bezier
