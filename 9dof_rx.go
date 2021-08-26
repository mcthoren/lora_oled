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

"${WT_DIR}/grab_48h" "${DAT_DIR}" 9dof.dat

cd /home/ghz/9dof/plots || exit 1
gnuplot "${NDoF_DIR}/linty.9dof.gnuplot"

sync

/usr/bin/rsync -ur --timeout=50 /home/ghz/9dof/ "${NDoF_DIR}/"
	wx_0x0a_sync:/wx_0x0a/ # 2> /dev/null

rm "${LOCK}"
