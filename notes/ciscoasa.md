---
layout: note
title: Cisco ASA
last_modified: 2009-05-30 13:36:00 -0400
---
#### Configuration

##### Add Domain Controllers as AAA Servers

In ASDM:

 * Configuration -> Remote Access VPN -> AAA/Local Users -> AAA Server Groups
 * Add AAA Server Group
 * Server Group: My LDAP Group
 * Protocol: LDAP
 * Add Servers in the AAA Server Group
 * Base DN: dc=domain,dc=local
 * Naming Attribute: sAMAccountName
 * Login DN: cn=Administrator,cn=Users,dc=domain,dc=local
 * Login Password: sekret123

##### Debugging

Getting Login Error or Login Denied and you know your password is right?? Log into the console and try some of the debugging commands (not recommended to turn on all at the same time on a heavily used server).

Turn on:

    debug webvpn svc 255
    debug dap trace
    debug ldap 255

Turn off:

    no debug webvpn svc
    no debug dap trace
    no debug ldap

