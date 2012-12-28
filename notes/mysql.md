---
layout: note
title: MySQL
excerpt: My notepad of MySQL commands and scripts that I can NEVER remember when I need to something.
last_modified: 2009-01-29 15:19:00 -0500
---
#### Initial Configuration

Change your MySQL root password:

    [root@vm]# mysqladmin -u root password new-password

or:

    [root@vm]# mysqladmin -u root -h fully-qualified-domain-name password new-password

fully-qualified-domain-name assumes you have changed your hostname via the hostname command.

#### New Users

    mysql> GRANT ALL ON *.* TO 'bob'@'%.mshome.local';
    mysql> SET PASSWORD FOR 'bob'@'%.mshome.local' = PASSWORD('NEWPASSWORD');

The command is divided up into two sections for security reasons. If you have multiple admins and you were setting your password to one of your usuals, then you can simply delete the password line from ~/.mysql_history without removing the line granting you an account (for accountability purposes).

#### Re-number an ID Field

Occasionally, you will need to delete a number of rows in an autonumber field. Should you then wish to renumber the sequence, perform the following steps:

    mysql> SET @var_name = 0;
    mysql> UPDATE tablename SET ID = (@var_name := @var_name +1);
    mysql> ALTER TABLE tablename AUTO_INCREMENT = x;

In the above statement, set the AUTO_INCREMENT variable to the number of rows affected plus one.

#### Change Password for User at all Hosts

    mysql> update mysql.user set password=PASSWORD('NEWPASSWORD') where User='username';
    mysql> flush privileges;

The line above changes the password for the user at each host mask.

**Background:** MySQL creates a new user on each host mask and your privileges can be assigned as such.

**Example:** A user, jsmith, has been granted all on *.* with a host mask of '10.1.1.%' (Inside). Two additional privilege sets has been created for jsmith granting read-only on app1.* with a host mask of '172.31.0.%' (DMZ), and granting all on app1.* from '192.168.0.%' (VPN). This allows jsmith to edit the entire system when on his work desktop, but only read app1 from the DMZ. Should he wish to VPN in, he has full access to the app1 database.

