#!/bin/sh

# meant to be called from cron every minute or so

LOCK='/home/ghz/9dof/9dof.lock'
WT_DIR='/import/home/ghz/repos/weather_tools'
DAT_DIR='/home/ghz/9dof/data'
NDoF_DIR='/import/home/ghz/repos/lora_oled'

[ -e "${LOCK}" ] && {
	echo "$0: lock exists" | logger
		exit 1
}

# lock is also checked for and deleted on boot, in case of a crash
touch "${LOCK}"

"${WT_DIR}/grab_48h" "${DAT_DIR}" 9dof_raw.dat

# seive out the 3 diff sensors. this opens up the possibility of stricter REs if necessary.
grep "mx:" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/mag.dat.2-3_day"
grep "gx:" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/gyro.dat.2-3_day"
grep "ax:" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/accel.dat.2-3_day"

cd /home/ghz/9dof/plots || exit 1
gnuplot "${NDoF_DIR}/linty.9dof.gnuplot"

sync

/usr/bin/rsync -ur --timeout=50 --exclude='.git' /home/ghz/9dof/ "${NDoF_DIR}/" \
	wx_0x0a_sync:/wx_0x0a/ # 2> /dev/null

rm "${LOCK}"
