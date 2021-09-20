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

A_PAT="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\tax:\ -?[0-9]{1,4}\.[0-9]{3}\ m\/s\^2\tay:\ -?[0-9]{1,4}\.[0-9]{3}\ m\/s\^2\taz:\ -?[0-9]{1,4}\.[0-9]{3}\ m\/s\^2$"
M_PAT="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\tmx:\ -?[0-9]{1,4}\.[0-9]{3}\ uT\tmy:\ -?[0-9]{1,4}\.[0-9]{3}\ uT\tmz:\ -?[0-9]{1,4}\.[0-9]{3}\ uT$"
G_PAT="^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\tgx:\ -?[0-9]{1,4}\.[0-9]{3}\ rad\/s\tgy:\ -?[0-9]{1,4}\.[0-9]{3}\ rad\/s\tgz:\ -?[0-9]{1,4}\.[0-9]{3}\ rad\/s$"

# lock is also checked for and deleted on boot, in case of a crash
touch "${LOCK}"

"${WT_DIR}/grab_48h" "${DAT_DIR}" 9dof_raw.dat

# seive out the 3 diff sensors. Stricter REs are necessary.
grep -aP "$A_PAT" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/accel.dat.2-3_day"
grep -aP "$M_PAT" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/mag.dat.2-3_day"
grep -aP "$G_PAT" "${DAT_DIR}/9dof_raw.dat.2-3_day" > "${DAT_DIR}/gyro.dat.2-3_day"

cd /home/ghz/9dof/plots || exit 1
gnuplot "${NDoF_DIR}/linty.9dof.gnuplot"

sync

/usr/bin/rsync -ur --timeout=50 --exclude='.git' /home/ghz/9dof/ "${NDoF_DIR}/" \
	wx_0x0a_sync:/wx_0x0a/ # 2> /dev/null

rm "${LOCK}"
