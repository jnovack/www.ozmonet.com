---
layout: note
title: rsnapshot
published: false
last_modified: 2014-08-12 13:37:00 -0400
---

Backup remote Linux hosts without root access, using rsnapshot
Why ?
Rsnapshot is a powerfull rotating snapshot utility.

RSnapshot rotations processing use hardlinks ; only the changed files are copied, the rest is hard linked to the most recent backup. This method reduce hard disk used space.

Using remote root ssh access, Rsnapshot is able to backup a whole distant host. But, as you know, this is not an elegant nor a secure solution.

How ?
Consider we have several Remote Hosts, and a Backup Server host.

We will use a common user (named backupuser).

From Backup Server, we will be able to log on each Remote Host using backupuser ssh public key.

The main trick is to set sudoers on Remote Host in order to allow rsync root access to backupuser, and tell rsnapshot to use additionnal parameters when calling RSync.

Let us see in details.

Setting Up
Backup Server Side
Create Backup User and generate ssh keys
sudo adduser backupuser
 
sudo su backupuser
 
ssh-keygen
 
exit
Copy ssh key to Remote Hosts
WORKUSER is your usual user on Remote Host

REMOTE is adress/ip of Remote Host

sudo scp /home/backupuser/.ssh/id_rsa.pub WORKUSER@REMOTE:
Set up Rsnapshot
sudo vim /etc/rsnapshot.conf
(Mind that separator MUST BE TAB and folders MUST ENDS WITH A TRAILING SLASH)

Uncomment this line

cmd_rsync       /usr/bin/rsync
Uncomment and modify these lines

rsync_long_args         -ev --rsync-path=/home/backupuser/rsync-wrapper.sh
ssh_args                -i /home/backupuser/.ssh/id_rsa
For each directory to backup, add this line at the end of the file

backup  backupuser@REMOTE:/PATH/     REMOTE_NAME/PATH/
To backup /etc of myremote.org :

backup  backupuser@myremote.org:/etc/     myremote_backup/etc/
Finally, configure rotations. I use 3 daily, 3 weekly and 3 monthly rotations

interval        daily   3
interval        weekly  3
interval        monthly 3
Set up Cron
sudo crontab -e
A cron task must be defined for each rotation type, mine is like this, according Rsnapshot config

#3am each day
0 3 * * *    /usr/bin/rsnapshot daily
#4am each week
0 4 * * 1    /usr/bin/rsnapshot weekly
#4am each month
0 4 1 * *    /usr/bin/rsnapshot monthly
Remote Host side
Repeat these steps for each remote

Log on to remote using your usual user (WORKUSER)

Set up user and ssh key
sudo useradd backupuser -c "limited backup user" -m -u 4210
sudo mkdir /home/backupuser/.ssh
sudo mv id_rsa.pub /home/backupuser/.ssh/authorized_keys (debian)
Create rsync-wrapper script
sudo vim /home/backupuser/rsync-wrapper.sh
Script content

#!/bin/sh
 
date >> /home/backupuser/backuplog
echo $@ >> /home/backupuser/backuplog
/usr/bin/sudo /usr/bin/rsync "$@";
(Once created, you can copy this file accross all remotes using scp)

sudo chown backupuser:backupuser /home/backupuser/rsync-wrapper.sh
sudo chmod 755 /home/backupuser/rsync-wrapper.sh
Edit Sudoers config
sudo vim /etc/sudoers

Add this line (This file is read only on debian systems, so ignore the warning)

backupuser ALL=NOPASSWD: /usr/bin/rsync
Defaults:backupuser !requiretty
Defaults:backupuser !visiblepw


Initialize
Each backupuser ssh connection must be initialized once.

From Backup Server, type :

ssh backupuser@REMOTE -i /home/backupuser/.ssh/id_rsa
Test
Before been called by your Cron tasks, you can test your backups calling Rnapshot manually.

rsnapshot daily
When finished, you can check the results in Rsnapshot directory (default on debian /var/cache/rsnapshot)

If repeated, you will see the rotations folders.

Sources
My first attempt to use Rsnapshot without root access was really complicated

Backup remote Linux systems without root access, using rsnapshot and rsync

Then, I have read this article on Linux Puzzle blog, and, after used it with success, I have deciced to write a bit more detailed tutorial about this elegant solution.

http://dev.kprod.net/?q=linux-backup-rsnapshot-no-root

https://marksallee.wordpress.com/2009/10/08/server-backups-with-rsnapshot-rsync-non-root-user/

Tags:
rsnapshot linux admin

