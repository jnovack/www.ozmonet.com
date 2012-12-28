---
layout: note
title: OSX
excerpt: Tips and tricks I've picked up and wrote down while trying to figure something out in OSX. Hopefully it saves you some banging of the head.
promote: true
last_modified: 2012-09-08 14:37:00 -0500
---
##### Enable AirDrop on Unsupported Macs and Unsupported Interfaces

    $ defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1
    $ killall Finder

This command will enable Airdrop file sharing over faster ethernet connections, and unlock the feature on "unsupported" Macs and Hackintosh builds. If you're attempting this trick with an older Mac, note that **both** machines in an AirDrop session, even if one is officially supported, will need to use this Terminal command in order to see each other.

##### Remotely Turn on Screen Sharing

    $ cd /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/
    $ sudo ./kickstart -activate -configure -access -on -privs -all -restart -agent

##### Screen Sharing.app
Why this isn't in `/Applications` or `/Utilities`, I'll never know. Perhaps, a "*genius*" can understand why. You can find it in `/System/Library/CoreServices/Screen Sharing.app`

##### Change Default Screen Shot Directory

    $ defaults write com.apple.screencapture location ~/Pictures/Screenshots/ && killall SystemUIServer

##### Fixing Corrupt Mobile Account

Copied from: [http://flybyunix.carlcaum.com/2010/05/fixing-corrupt-mobile-account-in-snow.html](http://flybyunix.carlcaum.com/2010/05/fixing-corrupt-mobile-account-in-snow.html)

It's rare, but sometimes mobile accounts (accounts that sync to an Active Directory/LDAP entry) can become corrupt and bad things happen as a result. Common symptoms are:

 * shells not being able to start
 * applications claiming you don't permission to do this-or-that
 * unable to log in as a previous user after rebinding to the domain

I still haven't found a good reason for this happening, but have discovered the corruption exists in `/Local/Default/Users/username` in the local Directory Service on the mac. Since the data is synced to Active Directory/LDAP, the easiest thing to do is simply delete the entry in Directory Service using `dscl`. Then when you log in with the account (using the Other option in the Login Window,) it will create a new mobile account and take over the home directory for the old account that you DIDN'T delete.

Since the uid is synced, the files in the home directory are owned by new mobile account. To delete the entry in Directory Service, run the following command replacing <user> with the username of the account to be removed.

    dscl . -delete /Users/username

