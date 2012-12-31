---
layout: note
title: Unnoc
excerpt:
status: stale
last_modified: 2008-07-26 22:49:00 +0000
---
I used Tru's VMware Repository as my host using the minimal install (CentOS-5.i386.zip under the most recent build date) for the smallest possible image on my VMware Server.

Additional notes on my VMware customization are located on the VMware page.

This is not exactly a cut-n-paste script as you will be prompted the first time you run through CPAN, but as far as the rest of the stuff goes, you should be OK.

This process VIOLATES SELinux policies, you will have to disable SELinux to complete this as is. If you wish to use SELinux, you must build an SELinux policy.

    # Install Dag's repository RPM
    rpm -Uhv http://apt.sw.be/redhat/el5/en/i386/dag/RPMS/rpmforge-release-0.3.6-1.el5.rf.i386.rpm

    # Install required packages from both repositories (separated for accounting purposes)
    yum -y install httpd php mysql mysql-server php-mysql perl subversion perl-Crypt-SSLeay perl-XML-LibXML perl-XML-Parser perl-Net-SNMP
    yum -y install perl-IO-Socket-SSL perl-Mail-POP3Client perl-Class-MethodMaker perl-Math-BigInt-FastCalc perl-libwww-perl rrdtool

    # Install Net-Ping-External from CPAN
    perl -MCPAN -e 'install Net::Ping::External'

    # Download, build, and install SNMP Session which includes the appropriate BER.pm
    cd ~
    wget http://www.switch.ch/misc/leinen/snmp/perl/dist/SNMP_Session-1.12.tar.gz
    tar -xzvf SNMP_Session-1.12.tar.gz
    cd SNMP_Session-1.12/
    perl Makefile.PL
    make test
    make install

    # Download, build, and install the Virtual Infrastructure Perl Toolkit
    cd ~
    wget http://superb-west.dl.sourceforge.net/sourceforge/viperltoolkit/viperltoolkit-beta1.zip
    unzip viperltoolkit-beta1.zip
    cd viperltoolkit/
    perl Makefile.PL
    make test
    make install

    # Download, build, and install Unnoc (Finally!)
    cd /usr/local/
    svn co https://unnoc.svn.sourceforge.net/svnroot/unnoc/trunk/ unnoc/
    cd unnoc/
    ./perl-module-checker.pl
    useradd unnoc
    chown -R unnoc.apache *

    # Configure MySQL
    cd /usr/local/unnoc/
    service mysqld start
    mysqladmin create unnoc
    mysql unnoc < mysql_table

    # Link Unnoc
    ln -s /usr/local/unnoc/unnoc/ /var/www/html/unnoc
    ln -s /usr/local/unnoc/unnoc/etc/unnoc.conf /etc/unnoc.conf
    # Configure Unnoc
    vi /etc/unnoc.conf
    # Startup
    cp /usr/local/unnoc/scripts/init.d/fedora/unnocd /etc/init.d/unnocd
    chkconfig --add unnocd
    vi /etc/init.d/unnocd
    chkconfig unnocd on
    service unnocd start

#### Customization
Set your MySQL password.

    mysql> grant all on unnoc.* to 'unnoc'@'localhost';
    mysql> set password for 'unnoc'@'localhost' = Password('unnoc');

