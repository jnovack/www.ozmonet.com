---
layout: note
title: RaspberryPi - Initial Setup from OSX
published: false
last_modified: 2013-07-19 13:37:00 -0400
---

```
[jnovack@gyarados ~]$ mount
/dev/disk2 on / (hfs, local, journaled)
devfs on /dev (devfs, local, nobrowse)
map -hosts on /net (autofs, nosuid, automounted, nobrowse)
map auto_home on /home (autofs, automounted, nobrowse)
/dev/disk3s1 on /Volumes/NO NAME (msdos, local, nodev, nosuid, noowners)

[jnovack@gyarados ~]$ sudo diskutil unmountDisk /dev/rdisk3
Unmount of all volumes on disk3 was successful

[jnovack@gyarados ~]$ sudo dd bs=1m if=2013-07-26-wheezy-raspbian.img of=/dev/rdisk3
1850+0 records in
1850+0 records out
1939865600 bytes transferred in 157.739122 secs (12297936 bytes/sec)
```

If you want to check on the status of `dd`, from another window run `killall -INFO dd`` or press `CTRL-T`.

