---
layout: note
title: Network-Wide Adblock
expert: How-To Impliment a Network-Wide Adblock solution for devices which cannot benefit from browser based adblocking.
status: stale
last_modified: 2008-10-23 00:00:00 +0000
---
#### Pre-Installation

My squid proxy is a CentOS 5 server running in a VM on a server. It doesn't really matter how you would like to install squid as long as it's on a machine which has an IP address which is addressable from the entire network (i.e. if you host it in a VM, it's best to use Bridging for your VM's ethernet card).

I will be using Tru's VMware Repository base image as a baseline for this walk-through. I suggest setting the Ethernet Adapter to "Bridge" mode, upping the RAM to 512, and removing the floppy and cdrom. The base image has nearly nothing installed; since everything needs to be installed, this is the safest install.

#### Squid

##### Installation
    [root@centos ~]# yum -y install squid

Umm.. that's it.

##### Configuration

Find and edit the following options in the /etc/squid/squid.conf file.
Edit the following two options to those below:

    url_rewrite_children 5
    url_rewrite_concurrency 0

Comment out ALL http_access lines and insert the following:

    acl our_networks src 192.168.10.0/24
    cache deny all
    http_access allow our_networks

Add the following line to the END of the file:

    redirect_program /usr/local/bin/squidGuard -d -c /usr/local/squidGuard/squidGuard.conf


If you have any issues, my squid.conf is attached below.

#### squidGuard

##### Installation
    [root@centos ~]# yum -y install gcc db4-devel byacc flex
    [root@centos ~]# wget http://www.squidguard.org/Downloads/squidGuard-1.3.tar.gz
    [root@centos ~]# tar -xzvf squidGuard-1.3.tar.gz
    [root@centos ~]# cd squidGuard-1.3
    [root@centos ~/squidGuard-1.3]# ./configure && make && make install 
    [root@centos ~/squidGuard-1.3]# cd /usr/local/
    [root@centos /usr/local]# mkdir squidGuard/db/adblock/
    [root@centos /usr/local]# touch squidGuard/db/adblock/expressions
    [root@centos /usr/local]# chown -R squid.squid squidGuard/

##### Configuaration

Edit /usr/local/squidGuard/squidGuard.conf appropriately. You will want to edit the settings to suit your network, a sample is provided below. Change "SERVERNAME" to your squid proxy server where required.

You will want to accomplish two things during this edit:

 * add another dest block to point to adblock/expressions (the regular expressions file we will be creating in the next step)
 * apply this dest to your src network via an acl

#### EasyList

##### A Brief History

Adblock Plus is probably by far my favorite piece of software. Mozilla Firefox makes it so easy to modify your browsing experience to how you like it. And a number of Gods (in my book) have written an extension for Firefox called Adblock Plus. It, just as the name implies, finds and locates offending items and removes them from the page to de-clutter your web browser.

Unfortunately, with so many ad-servers popping up each week, it was a pain to continually change your blocklist. Enter Easylist to save the day. Adblock Plus can automatically import a specially formatted text file from the web to be up-to-date on the latest changes in visual distractions.

##### Installation
     [root@centos ~]# wget http://easylist.adblockplus.org/adblock_rick752.txt
     [root@centos ~]# cat adblock_rick752.txt | sed -f adblock.sed > /usr/local/squidGuard/db/adblock/expressions
     [root@centos ~]# service squid restart

#### Appendix

adblock.sed

    /@@.*/d;
    /^!.*/d;
    /^\[.*\]$/d;
    s#http://##g;
    s,[.?=&/|],\\&,g;
    s#*#.*#g;
    s,\$.*$,,g;

squid.conf

    http_port 3128
    hierarchy_stoplist cgi-bin ?
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY
    acl apache rep_header Server ^Apache
    broken_vary_encoding allow apache
    access_log /var/log/squid/access.log squid
    log_ip_on_direct off
    url_rewrite_children 5
    url_rewrite_concurrency 0
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern .               0       20%     4320
    acl all src 0.0.0.0/0.0.0.0
    acl our_networks src 172.30.3.0/24
    cache deny all
    http_access allow our_networks
    http_reply_access allow all
    icp_access allow all
    visible_hostname SERVERNAME
    coredump_dir /var/spool/squid
    redirect_program /usr/local/bin/squidGuard -d -c /usr/local/squidGuard/squidGuard.conf

squidGuard.conf

    dbhome /usr/local/squidGuard/db
    logdir /var/log/squid
   
    src my_network {
        ip              192.168.1.0/24
    }

    dest adblock {
       expressionlist   adblock/expressions
       redirect         302:http://SERVERNAME/cgi-bin/squidGuard.cgi?clientaddr=%a&clientname=%n&clientident=%i&srcclass=%s&targetgroup=%t&url=%u
    }

    acl {
       my_network {
               pass     !adblock any
       }
       default {
               pass     none
               redirect 302:http://SERVERNAME/cgi-bin/squidGuard.cgi?clientaddr=%a&clientname=%n&clientident=%i&srcclass=%s&targetgroup=%t&url=%u
       }
    }

