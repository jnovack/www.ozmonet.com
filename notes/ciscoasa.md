---
layout: note
title: Cisco ASA
last_modified: 2009-05-30 13:36:00 -0500
---
Configuration
Add Domain Controllers as AAA Servers
In ASDM: Configuration -> Remote Access VPN -> AAA/Local Users -> AAA Server Groups
Add AAA Server Group
Server Group: My LDAP Group
Protocol: LDAP
Add Servers in the AAA Server Group
Base DN: dc=domain,dc=local
Naming Attribute: sAMAccountName
Login DN: cn=Administrator,cn=Users,dc=domain,dc=local
Login Password: sekret123
SSL VPN Client
Dynamic Access Policies through Active Directory Groups
Debug
Getting Login Error or Login Denied and you know your password is right?? Log into the console and try some of the debugging commands (not recommended to turn on all at the same time on a heavily used server).
Turn on:
debug webvpn svc 255
debug dap trace
debug ldap 255
Turn off:
no debug webvpn svc
no debug dap trace
no debug ldap
References
8.x: VPN Access with the AnyConnect SSL VPN Client Configuration Example
8.x: Mapping VPN Clients to VPN Group Policies Through LDAP Configuration Example
Microsoft Active Directory Policies Using LDAP Attribute Maps
How to configure LDAP authentication for VPN clients on ASA
8.x Dynamic Access Policies (DAP) Deployment Guide
8.x: Use LDAP Authentication to Assign a Group Policy at Login
ASA 8.x: AnyConnect VPN Client for Public Internet VPN on a Stick Configuration Example
