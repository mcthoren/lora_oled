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
plot accel_dat_f using 1:3 title 'Acceleration' with points linecolor rgb "#00ff00", \
accel_dat_f using 1:3 title 'Acceleration bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier
set output out_d.'accel_y.png'
plot accel_dat_f using 1:6 title 'Acceleration' with points linecolor rgb "#ff0000", \
accel_dat_f using 1:6 title 'Acceleration bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier
set output out_d.'accel_z.png'
plot accel_dat_f using 1:9 title 'Acceleration' with points linecolor rgb "#0000ff", \
accel_dat_f using 1:9 title 'Acceleration bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier

set title "Magnetometer Data over the Last \\~48 Hours"
set ylabel "Magnetic Field Strength (µT)"
set y2label "Magnetic Field Strength (µT)"
set output out_d.'mag_x.png'
plot mag_dat_f using 1:3 title 'Magnetic Field Strength' with points linecolor rgb "#00ff00", \
mag_dat_f using 1:3 title 'Magnetic Field Strength bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier
set output out_d.'mag_y.png'
plot mag_dat_f using 1:6 title 'Magnetic Field Strength' with points linecolor rgb "#ff0000", \
mag_dat_f using 1:6 title 'Magnetic Field Strength bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier
set output out_d.'mag_z.png'
plot mag_dat_f using 1:9 title 'Magnetic Field Strength' with points linecolor rgb "#0000ff", \
mag_dat_f using 1:9 title 'Magnetic Field Strength bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier

set title "Gyroscope Data over the Last \\~48 Hours"
set ylabel "Angular Velocity (rad/s)"
set y2label "Angular Velocity (rad/s)"
set output out_d.'gyro_x.png'
plot gyro_dat_f using 1:3 title 'Angular Velocity' with points linecolor rgb "#00ff00", \
gyro_dat_f using 1:3 title 'Angular Velocity bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier
set output out_d.'gyro_y.png'
plot gyro_dat_f using 1:6 title 'Angular Velocity' with points linecolor rgb "#ff0000", \
gyro_dat_f using 1:6 title 'Angular Velocity bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier
set output out_d.'gyro_z.png'
plot gyro_dat_f using 1:9 title 'Angular Velocity' with points linecolor rgb "#0000ff", \
gyro_dat_f using 1:9 title 'Angular Velocity bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier