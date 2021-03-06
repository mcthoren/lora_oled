#!/usr/bin/python3
# -*- coding: UTF-8 -*-

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

import time, busio, board, adafruit_ssd1306, adafruit_rfm9x, adafruit_fxos8700, adafruit_fxas21002c
from digitalio import DigitalInOut, Direction, Pull

btnA = DigitalInOut(board.D5)
btnA.direction = Direction.INPUT
btnA.pull = Pull.UP

btnB = DigitalInOut(board.D6)
btnB.direction = Direction.INPUT
btnB.pull = Pull.UP

btnC = DigitalInOut(board.D12)
btnC.direction = Direction.INPUT
btnC.pull = Pull.UP

reset_pin = DigitalInOut(board.D4)

i2c = busio.I2C(board.SCL, board.SDA)
mag_accel = adafruit_fxos8700.FXOS8700(i2c)
gyro = adafruit_fxas21002c.FXAS21002C(i2c)
display = adafruit_ssd1306.SSD1306_I2C(128, 32, i2c, reset=reset_pin)

display.fill(0)
display.show()
width = display.width
height = display.height

# Configure RFM9x LoRa Radio
CS = DigitalInOut(board.CE1)
RESET = DigitalInOut(board.D25)
spi = busio.SPI(board.SCK, MOSI=board.MOSI, MISO=board.MISO)

lh = 7 # letter height
flag_A = True
flag_B = False
flag_C = False

try:
	rfm9x = adafruit_rfm9x.RFM9x(spi, CS, RESET, 433.0)
	rfm9x.tx_power = 20
	display.text('RFM9x: Detected', 0, 0, 1)
except RuntimeError as error:
	# Thrown on version mismatch
	display.text('RFM9x: ERROR', 0, 0, 1)
	print('RFM9x Error: ', error)

display.show()
time.sleep(1.0)

last_press = time.time()
screen_saver = False
i = 0

try:
	while True:
		if not btnA.value:
			flag_A = True
			flag_B = False
			flag_C = False
			last_press = time.time()

		if not btnB.value:
			flag_A = False
			flag_B = True
			flag_C = False
			last_press = time.time()

		if not btnC.value:
			flag_A = False
			flag_B = False
			flag_C = True
			last_press = time.time()

		if ((time.time() - last_press) > 64):
			screen_saver = True
		else:
			screen_saver = False

		accel_x, accel_y, accel_z = mag_accel.accelerometer
		if flag_A and not screen_saver:
			display.fill(0)
			display.text('Acceleration (m/s^2):', 0, 0, 1)
			# height - gap pixels - # of rows
			display.text("x: {0:0.3f}".format(accel_x), 0, height - 2 - 3 * lh, 1)
			display.text("y: {0:0.3f}".format(accel_y), 0, height - 1 - 2 * lh, 1)
			display.text("z: {0:0.3f}".format(accel_z), 0, height - 0 - 1 * lh, 1)

		mag_x, mag_y, mag_z = mag_accel.magnetometer
		if flag_B and not screen_saver:
			display.fill(0)
			display.text('Magnetometer (uTesla):', 0, 0, 1)
			display.text("x: {0:0.3f}".format(mag_x), 0, height - 2 - 3 * lh, 1)
			display.text("y: {0:0.3f}".format(mag_y), 0, height - 1 - 2 * lh, 1)
			display.text("z: {0:0.3f}".format(mag_z), 0, height - 0 - 1 * lh, 1)

		gyro_x, gyro_y, gyro_z = gyro.gyroscope
		if flag_C and not screen_saver:
			display.fill(0)
			display.text('Gyroscope (radians/s):', 0, 0, 1)
			display.text("x: {0:0.3f}".format(gyro_x), 0, height - 2 - 3 * lh, 1)
			display.text("y: {0:0.3f}".format(gyro_y), 0, height - 1 - 2 * lh, 1)
			display.text("z: {0:0.3f}".format(gyro_z), 0, height - 0 - 1 * lh, 1)

		if i == 0:
			data_packet = bytes("ax: {0:0.3f} m/s^2\nay: {1:0.3f} m/s^2\naz: {2:0.3f} m/s^2\n".format(accel_x, accel_y, accel_z), "utf-8")
		if i == 1:
			data_packet = bytes("mx: {0:0.3f} uT\nmy: {1:0.3f} uT\nmz: {2:0.3f} uT\n".format(mag_x, mag_y, mag_z), "utf-8")
		if i == 2:
			data_packet = bytes("gx: {0:0.3f} rad/s\ngy: {1:0.3f} rad/s\ngz: {2:0.3f} rad/s\n".format(gyro_x, gyro_y, gyro_z), "utf-8")
			i = -1

		i += 1
		rfm9x.send(data_packet)

		if screen_saver:
			display.fill(0)

		display.show()
		time.sleep(0.9)

except:
	# can these screens burn? i don't know.
	display.fill(0)
	display.show()
