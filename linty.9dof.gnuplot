set xtics 7200 rotate by 30 offset -5.7, -2.2
set ytics
set mytics
set y2tics
set link y2
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

ax_cal='0.9411'
ay_cal='-0.3751'
az_cal='-0.4770'
ag_cal='-9.80605'

mx_cal='20.5599'
my_cal='85.4894'
mz_cal='68.8325'

accel_dat_f='/home/ghz/9dof/data/accel.dat.2-3_day'
gyro_dat_f='/home/ghz/9dof/data/gyro.dat.2-3_day'
mag_dat_f='/home/ghz/9dof/data/mag.dat.2-3_day'
out_d='/home/ghz/9dof/plots/'

# cal x accel against 0 with the assumption we shouldn't be measuring any accel outside the earth's
# rotation and orbit. assume we aren't sensitive enough to measure acceleration due to earth's rotation
# or orbit.
set title "Accelerometer Data over the Last \\~48 Hours"
set ylabel "Acceleration (x-axis) (m/s^2)"
set y2label "Acceleration (x-axis) (m/s^2)"
set output out_d.'accel_x.png'
plot accel_dat_f using 1:(($3 + ax_cal)) title 'Acceleration (x-axis)' with points linecolor rgb "#00ff00", \
accel_dat_f using 1:(($3 + ax_cal)) title 'Acceleration (x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier

# cal y accel with the same assumptions as x accel above.
set ylabel "Acceleration (y-axis) (m/s^2)"
set y2label "Acceleration (y-axis) (m/s^2)"
set output out_d.'accel_y.png'
plot accel_dat_f using 1:(($6 + ay_cal)) title 'Acceleration (y-axis)' with points linecolor rgb "#ff0000", \
accel_dat_f using 1:(($6 + ay_cal)) title 'Acceleration (y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier

# cal z-axis against standard gravity.
# avg reading across the last 119840 points is 10.2830688417915 m/s²
# std gravity is currently defined at: 9.80665 m/s²
# our local deviation is -60 mGal, or 0.0006 m/s², bringing our expected local gravity to 9.80605 m/s²
# 10.2830688417915 m/s² - 9.80605 m/s² = 0.4770188417915 m/s², so use that as our correction factor.
# in the end we only work with 2 digits after the decimial, cuz otherwise it would be silly.
set ylabel "Acceleration (z-axis) (m/s^2)"
set y2label "Acceleration (z-axis) (m/s^2)"
set output out_d.'accel_z.png'
plot accel_dat_f using 1:(($9 + az_cal)) title 'Acceleration (z-axis)' with points linecolor rgb "#0000ff", \
accel_dat_f using 1:(($9 + az_cal)) title 'Acceleration (z-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier

set ylabel "Acceleration (3-axis) (m/s^2)"
set y2label "Acceleration (3-axis) (m/s^2)"
set output out_d.'accel_3.png'
plot accel_dat_f using 1:(($3 + ax_cal)) title 'Acceleration (x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ff0000" smooth bezier, \
accel_dat_f using 1:(($6 + ay_cal)) title 'Acceleration (y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ff00" smooth bezier, \
accel_dat_f using 1:(($9 + az_cal + ag_cal)) title 'Acceleration (z-axis - gravity) bezier smoothed' with lines lw 2 linecolor rgb "#0000ff" smooth bezier

set title "Magnetometer Data over the Last \\~48 Hours"
set ylabel "Magnetic Field Strength (x-axis) (µT)"
set y2label "Magnetic Field Strength (x-axis) (µT)"
set output out_d.'mag_x.png'
plot mag_dat_f using 1:(($3 + mx_cal)) title 'Magnetic Field Strength (x-axis)' with points linecolor rgb "#00ff00", \
mag_dat_f using 1:(($3 + mx_cal)) title 'Magnetic Field Strength (x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier

set ylabel "Magnetic Field Strength (y-axis) (µT)"
set y2label "Magnetic Field Strength (y-axis) (µT)"
set output out_d.'mag_y.png'
plot mag_dat_f using 1:(($6 + my_cal)) title 'Magnetic Field Strength (y-axis)' with points linecolor rgb "#ff0000", \
mag_dat_f using 1:(($6 + my_cal)) title 'Magnetic Field Strength (y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier

set ylabel "Magnetic Field Strength (z-axis) (µT)"
set y2label "Magnetic Field Strength (z-axis) (µT)"
set output out_d.'mag_z.png'
plot mag_dat_f using 1:(($9 + mz_cal)) title 'Magnetic Field Strength (z-axis)' with points linecolor rgb "#0000ff", \
mag_dat_f using 1:(($9 + mz_cal)) title 'Magnetic Field Strength (z-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier

set ylabel "Magnetic Field Strength (3-axis) (µT)"
set y2label "Magnetic Field Strength (3-axis) (µT)"
set output out_d.'mag_3.png'
plot mag_dat_f using 1:(($3 + mx_cal)) title 'Magnetic Field Strength (x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ff0000" smooth bezier, \
mag_dat_f using 1:(($6 + my_cal)) title 'Magnetic Field Strength (y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ff00" smooth bezier, \
mag_dat_f using 1:(($9 + mz_cal)) title 'Magnetic Field Strength (z-axis) bezier smoothed' with lines lw 2 linecolor rgb "#0000ff" smooth bezier

set format y "%.3f"
set format y2 "%.3f"
set title "Gyroscope Data over the Last \\~48 Hours"
set ylabel "Angular Velocity (around the x-axis) (rad/s)"
set y2label "Angular Velocity (around the x-axis) (rad/s)"
set output out_d.'gyro_x.png'
plot gyro_dat_f using 1:3 title 'Angular Velocity (around the x-axis)' with points linecolor rgb "#00ff00", \
gyro_dat_f using 1:3 title 'Angular Velocity (around the x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#aa00aa" smooth bezier

set ylabel "Angular Velocity (around the y-axis) (rad/s)"
set y2label "Angular Velocity (around the y-axis) (rad/s)"
set output out_d.'gyro_y.png'
plot gyro_dat_f using 1:6 title 'Angular Velocity (around the y-axis)' with points linecolor rgb "#ff0000", \
gyro_dat_f using 1:6 title 'Angular Velocity (around the y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ffff" smooth bezier

set ylabel "Angular Velocity (around the z-axis) (rad/s)"
set y2label "Angular Velocity (around the z-axis) (rad/s)"
set output out_d.'gyro_z.png'
plot gyro_dat_f using 1:9 title 'Angular Velocity (around the z-axis)' with points linecolor rgb "#0000ff", \
gyro_dat_f using 1:9 title 'Angular Velocity (around the z-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ffff00" smooth bezier

set ylabel "Angular Velocity (around the 3-axis) (rad/s)"
set y2label "Angular Velocity (around the 3-axis) (rad/s)"
set output out_d.'gyro_3.png'
plot gyro_dat_f using 1:3 title 'Angular Velocity (around the x-axis) bezier smoothed' with lines lw 2 linecolor rgb "#ff0000" smooth bezier, \
gyro_dat_f using 1:6 title 'Angular Velocity (around the y-axis) bezier smoothed' with lines lw 2 linecolor rgb "#00ff00" smooth bezier, \
gyro_dat_f using 1:9 title 'Angular Velocity (around the z-axis) bezier smoothed' with lines lw 2 linecolor rgb "#0000ff" smooth bezier
