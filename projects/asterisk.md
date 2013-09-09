---
layout: note
title: Asterisk
excerpt: After having some money to burn, I decided to grab a Raspberry Pi and a a few Cisco IP phones.
promote: true
published: true
last_modified: 2013-07-19 00:00:00 +0000
---

#### Customization

##### OSS PBX End Point Manager

Under _Admin_ / _Module Admin_, install **OSS PSX End Point Manager** to easily add in additional types of phones.
This will install a few more options under the _Connectivity_ menu.

Navigate to _Connectivity_ / _OSS Endpoint Configuration_, and click the ```[Check for Updates]``` button.  After it is
complete, install the **Cisco** package and select your phones.  For this project, I installed the **7961G** and
the **SPA112** packages.



#### Phones

##### Cisco ATA for Analog Phones

I had owned a [Panasonic KX-TG7745S](http://www.amazon.com/dp/B0073W729K) from a previous failed experiment.  It just
did not link to my cell as reliably as I wanted it.  This product would be PERFECT for someone with a 900 sq. ft.
apartment when their cell phone is charging in an outlet and the owner is too lazy to get up off the beanbag chair to
answer the phone, they can reach over and use this.  Otherwise, in order to be within the 30 feet required for bluetooth
(less if you have an obstacle in the way), you might as well just pick up the damn cell phone.  But I digress...

In order to make this investment actually worth something, Cisco makes an Analog Telephone Adapter (ATA) to allow a
traditional cordless analog phone (or [hamburger phone](http://25.media.tumblr.com/tumblr_lyr7maLAlr1r65esmo1_500.jpg))
to register as a VoIP phone over an IP network.  The [Cisco SPA112](http://www.cisco.com/en/US/products/ps11977/) was a perfect fit.


The only change to get this working was that I needed to update the Dial Plan to the following: 

    ( xxx | xxxx | [23456789]11 | *xxx. | *xx | <:1352>[2-9]xxxxxx | <:1>[2-9]xx[2-9]xxxxxxS0 | 1[2-9]xx[2-9]xxxxxxS0 | 011xxxxxxx. | [#*x][*x][*x]. )

#### References:

  1.  [VoIP-Info.org Wiki - Asterisk Phone Cisco 7970 SIP](http://www.voip-info.org/wiki/view/Asterisk+phone+cisco+7970+SIP)
