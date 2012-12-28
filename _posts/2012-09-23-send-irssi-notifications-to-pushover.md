---
layout: post
title: pushover.pl - Send irssi notifications to Pushover
tags: [pushover, irssi, perl]
categories: [code]
excerpt: A custom script to send irssi notications such as /msg and highlights to the Pushover notification service.
---

After failing to find a irssi plugin which solved all my problems, I have created the following: [https://gist.github.com/3714183](https://gist.github.com/3714183)

Features:

 * Receive notifications from private messages, public messages, and hilights while away.
 * Duplicate suppression
 * Sets target (#channel, nick) as title to easily distinguish between private messages and public messages

<!--break-->
{% gist 3714183 %}
