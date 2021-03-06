#!/usr/bin/python3

# Thanks again to adafruit for all the sample code and boards!
#
# This is in large part hacked up code from:
# https://learn.adafruit.com/nxp-precision-9dof-breakout?view=all
# https://learn.adafruit.com/adafruit-radio-bonnets?view=all
# 
# which includes the follwing Author/Copyright info:
# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT
#
# Author: Brent Rubell for Adafruit Industries

import time, sys, busio, board, adafruit_ssd1306, adafruit_rfm9x
from digitalio import DigitalInOut, Direction, Pull

sys.path.append('/import/home/ghz/repos/wxlib')
import wxlib as wx

reset_pin = DigitalInOut(board.D4)
i2c = busio.I2C(board.SCL, board.SDA)
display = adafruit_ssd1306.SSD1306_I2C(128, 32, i2c, reset=reset_pin)

display.fill(0)
display.show()
width = display.width
height = display.height

# Configure RFM9x LoRa Radio
CS = DigitalInOut(board.CE1)
RESET = DigitalInOut(board.D25)
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)

try:
	rfm9x = adafruit_rfm9x.RFM9x(spi, CS, RESET, 433.0)
	display.text('RFM9x: Detected', 0, 0, 1)
	rfm9x.tx_power = 5
except RuntimeError as error:
	# Thrown on version mismatch
	display.text('RFM9x: ERROR', 0, 0, 1)
	print('RFM9x Error: ', error)

display.show()
time.sleep(1.0)

dat_fname = '9dof_raw.dat'
# note: this isn't /import/home, this is on the SD card
wx_dir = "/home/ghz/9dof"

last_packet = time.monotonic()
screen_saver = False
i = 0

try:
	while True:

		packet = None
		packet = rfm9x.receive()
		if packet is None:
			display.fill(0)
			if i == 0:
				display.text('Waiting for PKT', 21, 21, 1)
			if i == 1:
				display.text('Waiting for PKT.', 14, 14, 1)
			if i == 2:
				display.text('Waiting for PKT..', 7, 7, 1)
			if i == 3:
				display.text('Waiting for PKT...', 0, 0, 1)
				i = -1
			display.show()
			i += 1
			last_packet = time.monotonic()
		else:
			# Display the packet text and rssi
			display.fill(0)
			prev_packet = packet
			try:
				ts = time.strftime("%FT%TZ", time.gmtime())
				packet_text = str(prev_packet, "utf-8")
				display.text(packet_text, 0, 0, 1)
				print(packet_text)
				wx.write_out_dat_stamp_iso(ts, dat_fname, ts+'\t'+packet_text.rstrip().replace("\n", "\t")+'\n', wx_dir)
				last_packet = time.monotonic()
			except:
				# throw away, try again.
				packet_text = None
			time.sleep(1)

		if ((time.monotonic() - last_packet) > 64):
			screen_saver = True
		else:
			screen_saver = False

		if screen_saver:
			display.fill(0)

		display.show()
		time.sleep(0.2)

except:
	# can these screens burn? i don't know.
	display.fill(0)
	display.show()
