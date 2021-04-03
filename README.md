#### This is a project to collect magnetometer, accelerometer and gyroscope data, send it over a LoRa radio and also display it on an OLED.

To install the prerequisites one needs sth like the following:
* apt install python3-pip
* pip3 install adafruit-circuitpython-ssd1306 adafruit-circuitpython-framebuf adafruit-circuitpython-rfm9x adafruit-circuitpython-fxos8700 adafruit-circuitpython-fxas21002c

##### Many thanks to Adafruit for all the wonderful docs, boards, and examples.
* Docs can be found here:
  * https://learn.adafruit.com/nxp-precision-9dof-breakout?view=all
  * https://learn.adafruit.com/adafruit-radio-bonnets?view=all


This code can be found in the following places:
* https://github.com/mcthoren/lora_oled

to do:
- [x] lic
- [x] readme
- [x] protoype hardware
- [x] build hardware
- [x] test hardware
- [ ] an enclosure might be nice?
- [ ] send data over LoRa
- [ ] receive data over LoRa
- [ ] hook up plotting
- [ ] webpage
- [ ] calibrate
