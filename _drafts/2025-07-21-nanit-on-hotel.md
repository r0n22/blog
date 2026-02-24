---
layout: post
title: 
date: 2025-07-21 19:35
category: 
author: 
tags: []
summary: 
---

# Nanit on Hotel Wifi

We are going on a trip and wanted to use our current baby camera while we were away.  It is connected to the network so it cannot handle a captive portal for login.

I always wanted to get a travel router like the GL.Net but I already have so many devices I didn't think that it was worth it.

I stumbled upon the [RaspAP](https://raspap.com/) which I had a raspberry pi lying around and thought why don't we give this a try.

You can download the latest image from [its github repo](https://github.com/RaspAP/raspap-webgui/releases/)

You will need for this project:

* SD Card (Does not need to be big I am using 8 GB)
* USB Wifi Adapter
* Raspberry Pi


I will be installing in on a Raspberry Pi 3B so performance will not be stellar but we will not be streaming multiple video's from it.

Install it with the your flavour of media burner (dd, [Raspberry Image Writer](https://www.raspberrypi.com/news/raspberry-pi-imager-imaging-utility/))

```bash
$dd if=2025-07-15-raspap-bookworm-arm64-lite-3.3.8.img of=/dev/mmcblk0 bs=16M status=progress
```

Once installed plug in your SD card and a secondary USB wifi adapter.

And boot up the raspberry pi.

The reason why you need the secondary usb wifi adapter is to allow for the system to use one adapter to connect to the hotel wifi and the second to act as our hotspot for our devices.

## Setup

Once you have connected to power you should be able to find the new wifi access point in your computer.

The defaults connecting are as follows:

**IP address:** 10.3.141.1
**Username:** admin
**Password:** secret
**DHCP range:** 10.3.141.50 to 10.3.141.254
**SSID:** RaspAP
**Password:** ChangeMe

Please change both the user/pass and the SSID/password as defaults can allow others to access your network.


