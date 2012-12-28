---
layout: post
title: pushover.pl - Send irssi notifications to Pushover
tags: [pushover, irssi, perl]
categories: [code]
excerpt: A custom script to send irssi notications such as /msg and highlights to the Pushover notification service.
---

After failing to find an irssi plugin which solved all my problems, I had to write my own.

#### Features

 * Receive notifications from private messages, public messages, and hilights while away.
 * Duplicate suppression
 * Sets target (#channel, nick) as title to easily distinguish between private messages and public messages

<!--break-->
#### Code
{% gist 3714183 %}

#### References

 1. [https://gist.github.com/3714183](https://gist.github.com/3714183)
 2. [http://www.denis.lemire.name/2009/07/07/prowl-irssi-hack/](http://www.denis.lemire.name/2009/07/07/prowl-irssi-hack/)
 3. [http://www.geekfarm.org/wu/muse/scripts/growl-notify.txt](http://www.geekfarm.org/wu/muse/scripts/growl-notify.txt)
