---
layout: note
title: RGB LED Strip Lights
excerpt: Control RGB strip lights with an Adafruit PWM and a Raspberry Pi running NodeJS.  Just in time for the Holidays.
promote: true
published: true
status: current
last_modified: 2013-09-19 13:37:00 -0400
---

#### Preface

There are hundreds, if not thousands, of coding examples in Python and for the Arduino for this exact project.
I do not know Python, and I do not have an Arduino, thus I wanted to port this project to a language and platform
I was familiar with.

#### Introduction

This project is designed to be a web-addressable RGB lighting experiment in NodeJS on a RaspberryPi.  The goal is
to create a basic webpage (served by NodeJS) to control the RGB LED strip.  In addition to the front-end, I want
to provide a REST API to both set and get the parameters.

#### Hardware

The following is a parts list that I purchased from [adafruit.com](adafruit.com).

* 1x Raspberry Pi Model B 512MB RAM [ID:998] = $39.95
* 1x Adafruit 24-Channel 12-bit PWM LED Driver - SPI Interface - TLC5947 [ID:1429] = $14.95
* 1x RGB LED weatherproof flexi-strip 30 LED - (1m) [ID:285] = $16.00
* 1x Adafruit Half-size Perma-Proto Raspberry Pi Breadboard PCB Kit = $5.95
* 3x N-channel power MOSFET (30V / 60A) [ID:355] = $3.75
* 1x 12V 5A switching power supply [ID:352] = $24.95

Additionally, from Radio Shack or other electronics supply store.

* 1x 1k Ohm (1/4 watt) Resistors (5 Pack) [ID: 2711321] = $1.49 

If this is your first project or your toolkit is empty, you should stock up on the following:

* Adafruit Assembled Pi Cobbler Breakout + Cable for Raspberry Pi[ID:914] = $7.95
* Full sized breadboard[ID:239] = $7.95
* Extra-long break-away 0.1in 16-pin strip male header (5 pieces) [ID:400] = $3.00
* Break-away 0.1in 36-pin strip male header (10 pieces) [ID: 392] = $7.50
* Female/Female Jumper Wires - 40 x 6in = $6.95
* Male/Male Jumper Wires - 40 x 6in = $7.95

Notably missing, is a case, a 5V Micro USB power supply and a 4GB SD card for the Raspberry Pi.

##### Notes

I found the Solderless Analog RGB LED Strip Clip Sampler [ID:1004] AWFUL!  They are aggravating and annoying
to line up all four wires at the same time.  Buy yourself meters of four-wire RGB+ cable from Amazon and use
solder and heat-shrink tubing.

The Breadboarding wire bundle [ID:153] was less than fantastic, the pins were too thin.  Since your final
project will sit on the Perma-Proto board, just buy Female/Female jumper wires and pinheaders. Found the
jumpers cheaper on Amazon.

The LEDs are nice, but you can get 5 METERS for the same price from a no-name brand on Amazon. I bought 3
strips, and each of them worked just fine, and just as bright.

#### Wiring Diagram

<img src="http://i.imgur.com/kxdTt4K.png">

##### The Circuit

The circuit generally follows [this tutorial](http://learn.adafruit.com/rgb-led-strips/usage).

* Hook up the RPi to the 24-channel PWM breakout board.
* Connect the 3.3V output from the RPi to V+ on the 24-channel PWM breakout board.
* Connect the +12V from the LED strip to an external power supply (do NOT use your pi for this!)
* Connect the ground side of the power supply to the RPi ground
* I used the N-channel MOSFETs - three of them, one for each channel.
* We will use the PWM outputs to connect to the MOSFETs Gates.
  * Connect up the PWM output 0 to the MOSFET with the red wire from the LED strip.
  * Output 1 goes to green
  * Output 2 goes to blue.
* Connect the channel V+ line to the MOSFET Gates through the 1k resistor.

#### Getting Started

_What do you mean we are not started yet??_  Relax, this project has a lot of moving (figuratively) parts to it.
Go order your parts, then finish reading the rest of the tutorial.  By the time you are finished, your parts
should have arrived.

##### Operating System

Adafruit recommends their own easy-to-use distro Occidentalis. I have no experience with it.  I will stick with
Raspbian, but does require additional configuration.  For this project, I used `2013-07-26-wheezy-raspbian`.

Once you complete the setup and upgrade of your image, remove (or comment out, with a #) the following line in
`/etc/modprobe.d/raspi-blacklist.conf`.

    blacklist i2c-bcm2708
    blacklist spi-bcm2708

Second, add the following lines to `/etc/modules` and reboot.

    i2c-bcm2708
    i2c-dev

Unfortunately, there is no way to tell if the SPI device is connected and working.

##### Software

Download and extract the latest version of node.

    wget http://nodejs.org/dist/v0.10.17/node-v0.10.17-linux-arm-pi.tar.gz
    tar xvzf node-v0.10.17-linux-arm-pi.tar.gz

Create and copy the binaries to their new home, give the current user ownership of the directory.

    sudo mkdir /opt/node
    sudo cp -r node-v0.10.17-linux-arm-pi/* /opt/node
    sudo chown -R $USER /opt/node

Set up login scripts. Copy the following into `/etc/bashrc` (`/etc/bashrc` gets run on non-interactive
shells, allowing you to run ssh commands, e.g. `ssh pi@rpi -c node index.js`).

    NODE_JS_HOME="/opt/node"
    PATH="$PATH:$NODE_JS_HOME/bin"

This setup allows you to quickly and efficiently upgrade `node` as desired and easily install a package
globally (`npm install -g package`) without requiring sudo.

##### The Application

The top layer is just my own doing, but stands upon the shoulders of [node-leddriver](https://github.com/fjw/node-leddriver).

The source for my application is located at [https://github.com/jnovack/rpiled.js](https://github.com/jnovack/rpiled.js)

#### References

1. [https://github.com/fjw/node-leddriver](https://github.com/fjw/node-leddriver)
1. [https://github.com/fjw/node-simplespi](https://github.com/fjw/node-simplespi)
1. [https://github.com/pandringa/piStuff/blob/master/pwmTest.js](https://github.com/pandringa/piStuff/blob/master/pwmTest.js)
1. [https://github.com/smithje/RGB_LED_Driver](https://github.com/smithje/RGB_LED_Driver)
1. [https://github.com/kelly/node-i2c](https://github.com/kelly/node-i2c)
1. [https://github.com/technicalmachine/servo-pca9685](https://github.com/technicalmachine/servo-pca9685)
1. [http://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c](http://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c)
1. [http://learn.adafruit.com/adafruit-16-channel-servo-driver-with-raspberry-pi/configuring-your-pi-for-i2c](http://learn.adafruit.com/adafruit-16-channel-servo-driver-with-raspberry-pi/configuring-your-pi-for-i2c)
1. [http://blog.rueedlinger.ch/2013/03/raspberry-pi-and-nodejs-basic-setup/](http://blog.rueedlinger.ch/2013/03/raspberry-pi-and-nodejs-basic-setup/)
1. [http://www.instructables.com/id/Breadboard-Basics-for-Absolute-Begginers/](http://www.instructables.com/id/Breadboard-Basics-for-Absolute-Begginers/)
