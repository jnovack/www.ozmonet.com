---
layout: note
title: Simple Event Correlator
promote: true
excerpt: Configurations and scripts I found collected while using the most awesomest piece of code written for parsing log files.
last_modified: 2011-12-28 17:42:00 -0500
---
Simple Event Correlator (sec.pl) is AWESOME. But you probably came here knowing that.

#### Defining a Map for Data

##### Problem

I had a number of ports on a switch that needed to be identified individually. To the server team, merely saying Gi3/39 on 4THFLSWITCH was down did not mean diddly-squat. To be efficient, they needed proper server names.

##### Solution

Rather than build *x* number of rules for each port, containing names and actions, I combined ALL the rules using a hashmap. First, I created a `friendlynames.txt` which held the translations. In the .sec file, first load all the hashes as contexts. Then, when a monitored line comes through with a matching pattern it will trigger the action ONLY if the hash exists (checked as a context). Finally, return the hash as a variable and do what you will with it.

##### /etc/sec/friendlynames.txt

    GigabitEthernet1/37=TEST SERVER
    GigabitEthernet3/39=IMPORTANT SERVER

##### /etc/sec/testing.sec

    type=Single
    desc=Load hashes at startup
    ptype=SubStr
    continue=TakeNext
    pattern=SEC_STARTUP|SEC_RESTART
    context=SEC_INTERNAL_EVENT
    action=eval %a ( open(FILE, "</etc/sec/friendlynames.txt"); \
            while (<FILE>) { chomp; my ($key, $val) = split /=/; $hash{"$key"} = $val; })

    #Aug  1 12:14:54 switchname 362351: %LINK-3-UPDOWN: Interface GigabitEthernet1/37, changed state to down
    type=Single
    desc=Fire Event
    ptype=RegExp
    pattern=%LINK-3-UPDOWN: Interface ([\w\/]+), changed state to down
    context= =($hash{"$1"})
    action=eval %host ( return $hash{"$1"}; ); logonly **** Uh-oh! Problem with %host ****

#### Credits
Thanks to the crew at the Simple-Evcorr Mailing List for their assistance.

 1. [http://www.mail-archive.com/simple-evcorr-users@lists.sourceforge.net/msg00980.html](http://www.mail-archive.com/simple-evcorr-users@lists.sourceforge.net/msg00965.html)
 2. [http://www.mail-archive.com/simple-evcorr-users@lists.sourceforge.net/msg00980.html](http://www.mail-archive.com/simple-evcorr-users@lists.sourceforge.net/msg00980.html)
