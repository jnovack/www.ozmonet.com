---
layout: note
title: NeDi
status: stale
promote: false
last_modified: 2008-06-14 00:00:00 +0000
---
I used Tru's VMware Repository as my host using the minimal install (CentOS-5.i386.zip under the most recent build date) for the smallest possible image on my VMware Server.

Additional notes on my VMware customization are located on the VMware page.

This process VIOLATES SELinux policies, you will have to disable SELinux to complete this as is. If you wish to use SELinux, you must build an SELinux policy.

This is not exactly a cut-n-paste script as you will be prompted the first time you run through CPAN, but as far as the rest of the stuff goes, you should be OK.

#### Install

    # Install Dag's repository RPM
    rpm -Uhv http://apt.sw.be/redhat/el5/en/i386/dag/RPMS/rpmforge-release-0.3.6-1.el5.rf.i386.rpm
    
    # Install all packages (separated for accounting purposes)
    yum -y install httpd php php-mysql mysql-server php-snmp php-gd
    yum -y install perl-Net-Telnet-Cisco perl-Algorithm-Diff perl-Net-Telnet perl-Net-SNMP net-snmp rrdtool perl-Net-SSH

    # Start up services
    service httpd start
    service mysqld start
    
    # Download and install NeDi
    wget http://www.nedi.ch/lib/exe/fetch.php?id=files%3Adownload\&cache=cache\&media=files\:nedi-1.0.tgz
    tar -xzvf nedi-1.0.tgz
    mv nedi /usr/local/nedi
    useradd -l nedi -g apache -s /bin/bash -d /usr/local/nedi/
    mkdir /usr/local/nedi/log
    ln -s /usr/local/nedi/nedi.conf /etc/nedi.conf
    ln -s /usr/local/nedi/html/ /var/www/html/nedi
    chmod 775 –R /usr/local/nedi
    chmod 775 –R /var/www/html
    chown nedi:apache –R /usr/local/nedi
    chgrp apache –R /var/www/html
    
    # Edit nedi.conf with your settings
    vi /etc/nedi.conf
    
    # Set NeDi to run every half-hour
    su nedi -
    crontab –e
        0 0 * * * /usr/local/nedi/nedi.pl -b > /usr/local/nedi/log/nedi-backup.lastrun 2>&1
        30 0 * * * /usr/local/nedi/nedi.pl -cod > /usr/local/nedi/log/nedi.lastrun 2>&1
        */30 1-23 * * * /usr/local/nedi/nedi.pl -cod > /usr/local/nedi/log/nedi.lastrun 2>&1

