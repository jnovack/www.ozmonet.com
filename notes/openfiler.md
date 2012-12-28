---
layout: note
title: Openfiler
excerpt: Openfiler has an ABYSMAL support forum, they want you to pay for every piece of support, including the Administration Guide. The documentation is awful and the user community is not active. I merely documented my findings so nobody else has to go through the pain of sifting through their awful forums. Yes, I do still use my Openfiler, it works for me(tm), and I do like it.
promote: true
last_modified: 2009-03-31 15:48:00 -0500
---
If you are looking for a nice easy NAS/SAN appliance, this is not the page you should be reading. Openfiler has an ABYSMAL support forum, they want you to pay for every piece of support, including the Administration Guide. The documentation is awful and the user community is not active. I merely document my findings so nobody else has to go through the pain of sifting through their awful forums. Yes, I do still use my Openfiler, it works for me(tm), and I do like it.

Consider this an "Openfiler Quick Configuration Guide".

Pre-Installation
My installation was on a HP DL320s Storage Server. Excessive? Yes. Fun? Yes.
Using HP's Array Configuration Utility, I created two (2) separate logical volumes on one (1) RAID array. I wanted my OS to be on one logical volume, and the data to be on the other. The array consisted of a RAID 6 (you can never have too much parity) on disks 1 through 12 for maximum protection.
Installation
I burned Openfiler 2.3 to a CD and booted from it. The install was a very simple Linux install you've seen many times before if you have ever installed Redhat/Fedora.
During the installation, I did NOT partition or format the DATA volume (the second RAID volume)
Configuration
The server booted up successfully and displayed the main login screen.
Change DATA Volume to GPT
Since the DATA volume needs to be larger than 2TB, I need to change the type from msdos to GPT (GUID Partition Table). Configuration of the partition/drive will take place in the GUI.
[root@openfiler ~]# parted /dev/cciss/c0d1
(parted) mklabel GPT
(parted) quit
Update
The next step is to update the system and reboot for the changes to take effect.
[root@openfiler ~]# conary update conary
[root@openfiler ~]# conary updateall
[root@openfiler ~]# reboot
NIC Bonding
http://www.cyberciti.biz/tips/linux-bond-or-team-multiple-network-interfaces-nic-into-single-interface.html
Run on Normal HTTPS Port
Openfiler runs on port 446 for some ungodly reason. Since it has it's own IP address, and nothing else is running on the box, there's no reason to keep it on this obscure port and confuse people. The first command does the magic, the other two just change system messages so you aren't confused as to where to go.
[root@openfiler ~]# sed -i "s/446/443/g" /opt/openfiler/etc/httpd/conf/httpd.conf
[root@openfiler ~]# find /etc -iname "*distro-release" -exec sed -i "s#:446##g" {} \;
[root@openfiler ~]# find /etc -iname "issue*" -exec sed -i "s#:446##g" {} \;
[root@openfiler ~]# service openfiler restart
The rest can be done through the administration interface.
Administration
NOTE: Before creating any volumes, ensure the system is setup how you like. It is easier to change/reinstall now, than later.
Network Access Configuration
This section creates a logical list of networks which you can create access control lists (ACLs) for your network. If you want to use iSCSI, you must create a network.
Click System
Under Network Access Configuration, create a friendly name, host and mask for a new Share.
Examples:
Name: Home Network
Network/Host: 192.168.1.0
Netmask: 255.255.255.0
Name: ESX Server
Network/Host: 192.168.1.10
Netmask: 255.255.255.255
By creating these two networks, I can give my ESX Server access to a particular LUN without the whole network seeing it.
Volume Management
Now that you have a large area for data, how do you carve it up? Naturally, it's not as intuitive as one might think so let's take the steps one at a time. My data is HARDWARE RAIDed, so I will not take any steps to create a software RAID.
Creating a Physical Volume
This is fancy talk for creating a partition. Why are we constantly switching terminology to confuse a new user? Who the hell knows. Learn it and keep up.
Click on Volumes -> Block Devices to access the Physical Volume creation page.
Edit the end cylinders for your desired space size (click out of the box to see the Size change)
Click Create
For MOST purposes, you are going to want one (1) single partition to store all your data. This partition can hold XFS, ext3 and iSCSI LUNs. If you feel like getting creative, you can divide your space out. Remember, you cannot extend your partitions or LUNs (easily), so make sure you have enough for growth.
Creating a Volume Group
Volume groups can contain multiple partitions.
Click Volumes -> Volume Groups to create a volume group.
Name your volume group and add your partitions.
Click Create
I named my volume group "storage" because I'm uncreative. On the system, this will become /mnt/storage/.
Add Volumes
FINALLY we get to add volumes, but this is just the first half of actually sharing anything.
Volumes are separate entities which are under a volume group. Volumes can be XFS, ext3, and iSCSI LUNs which you can mix and match.
Click Volumes -> Add Volume
Enter in a volume name: no spaces, no fancy characters.
Enter in a volume description which can more accurately describe the volume via the web interface.
Enter in (or slide to) the amount of space in MB required.
Select the type of LUN or volume you want to create.
Click Create
I created a large XFS volume for my data with a few smaller iSCSI LUNs for my individual purposes (Time Machine for my Macbook, VMware VMFS volumes over iSCSI).
LDAP Setup
Once you have created all your volumes, it is your best interest to create accounts. I have decided to not be a member of the domain (I'm such a rebel) and manage LDAP locally.
Click on Accounts / Authentication
Check Use LDAP
Check Use Local LDAP
Server: 127.0.0.1
Base DN: dc=openfiler,dc=nas
Root bind DN: cn=Manager,dc=openfiler,dc=nas
Root bind password: your_root_password
It is in your best interest to create users and groups at this point.
iSCSI Setup
You must have LUNs and Networks setup at this point.
Click on Services -> iSCSI target server -> Enable
Click on Volumes -> iSCSI Targets
Give the Target IQN a friendly name for the initiator.
ONLY Edit after the final colon. iqn.2006-01.com.openfiler:tsn.1cb47a40ebf902 becomes iqn.2006-01.com.openfiler:share01
Click Add
Select LUN Mapping.
Map the selected LUNs to the target we've just created by clicking Map
You may add additional LUNs to the target, by repeating this step
Select Network ACL
Change the drop-down to Allow for each network you'd like access to this iSCSI target.
Click Update
Select CHAP Authentication
I recommend adding authentication to your iSCSI, but if you don't care, you don't have to.
Enter a username, password and select the Incoming User type.
Click Add
You have successfully created a secure iSCSI target and may now connect to it.
Network Shares
At this point, we have a completely blank drive ready for data!
Before we can make shares, we have to make directories.
Click on Shares
Click on the link for your volume and create a sub-folder.
Click on the link for your new sub-folder and Make Share
Scroll down to "Group Access Configuration"
Select a group to be your primary group.
Select permissions for the rest of your groups.
Scroll down to "Host Access Configuration"
Select the MAXIMUM ALLOWABLE permissions for your networks
If your network is set to "RO" (Read-Only), but your users accessing the share from your network are "RW" (Read-Write), you will only have "RO" permissions.
To actually start the services:
* Click on Services -> SMB / CIFS server -> Enable
* Click on Services -> NFSv3 server -> Enable

#### Customization
**ACLs on XFS**
I had some issues with ACLs on an XFS. Maybe I did something wrong. In the meantime, I just disabled all ACLs on my /mnt/ partition.
    [root@openfiler ~]# setfacl -R -b /mnt/

References
http://www.petri.co.il/use-openfiler-as-free-vmware-esx-san-server.htm
http://www.petri.co.il/connect-vmware-esx-server-iscsi-san-openfiler.htm

