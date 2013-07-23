---
layout: note
title: Transporter 
promote: false
excerpt: Dealings with Connected Data with the Transporter 
last_modified: 2013-07-23 00:00:00 -0400
---

My Transporter from Connected Data is a hunk of shit.  It is SUPPOSED to be a private cloud solution that offers all the sharing, remote access and offsite backup advantages of Dropbox.  In my experience, the device is garbage and the Support team is worthless.  As you can read, they are intentionally avoiding any technical answers because they just do not fucking know.

The reason for the support was to diagnose why a folder copied from into the "Connected Data" folder was not being properly synced on the second computer.  It is supposed to accomplish the same goal as Dropbox.  Drop a file on your computer into the synced folder, watch it appear on the other computer within the same folder.  This does not happen.

#### May 11

As the initial communication was submitted via the web interface, I do not have a copy of it, the rest are emails.

    Support,
    
    I am having trouble trusting my transporter.  After creating a folder on my transporter, and enabling Local Copy on two computers, I dropped some data into the folder.  Fourteen hours later, I am not seeing it synchronized with my other computer despite "Everything is up-to-date" showing in the desktop application on both systems.  However, when I click Info on the destination computer, it showing as 5MB, not 17G.  Also, the transporter website shows only 8GB is in the folder.
    
    How long does the data take to sync?

----

    Hi Justin,

    Thank you for contacting Connected Data Support Center. This email is in regards to case number #320652 : The recommended way.
    
    Remember, the Desktop Software tries to work in the background.The usage of the SMB/CiFS connection would give you faster transfer rates.  Activate this feature in your Web-Admn screen.
    
    Kind regards,
    
    Connected Data Support
    Phone: 1-888-964-4607
    Mon - Fri ( 8am-8pm EST) Sat & Sun ( 9am-5pm EST)

#### May 14

    Support,

    I'm still having trouble trusting my transporter.  As shown in the screenshot http://cl.ly/image/2q0B1Z3y112o the bottom machine was the source, and the top machine was the destination.  This screenshot was taken 14 hours after dropping the iPhoto Library into the /Users/jnovack/Connected Data/Aperture/ folder on my source box. 

    The source shows the full 17GB of data (as it should). However, the destination shows only a folder of 5MB, and my transporter online (username: jnovack) shows only 8GB.  All the while the sync application says "Everything is up-to-date!".

    How can I trust that my Destination computer is ready to leave my network and work offline?  How can I trust that the transporter has the full copy in case my source blows up?

    Wearily,
    Justin

#### May 29

    Support, 

    I've been waiting for an answer for 14 days now (10 business), and the first response did not adequately answer my query.

    I am not happy with my device, and I am not happy waiting 14 days with no response.   Should I just return the device?

    Patiently,
    Justin

#### June 6

Resubmitted last question via the web interface as it appears that nobody reads emails for 3 weeks.

    Hi Justin,

    Thank you for contacting Connected Data Support Center. This email is in regards to case number #324826 : Transporter Online Case Form.

    Kind regards,

    Connected Data Support
    Phone: 1-888-964-4607
    Mon - Fri ( 8am-8pm EST) Sat & Sun ( 9am-5pm EST)

#### June 10

    Hi Justin,
    Thank you for contacting Connected Data Support Center. This email is in regards to case number #324826 : Lack of responce..

    I can see about looking in to the case for you, do you have a reference number from the case from a month ago or what seemed to be the nature of the problem?


    Kind regards,

    Connected Data Support
    Phone: 1-888-964-4607
    Mon - Fri ( 8am-8pm EST) Sat & Sun ( 9am-5pm EST)

----

    Case 320652.  The main issue is, I am not 100% confident my files are being "transported" properly. There is no indication it is not up to date (even when both machines say "up to date".

    The recommended answer I recieved was to drop files on the Transporter, and it will disperse them.  That's great, but if the whole point is to access your files when you are away, if I make a change on a remote offline laptop, it takes DAYS for the files to sync once back online.

    I understand a new version of the software will be coming out.  It is expected to be more "dropbox-like" or is the transporter more of a "read from the central repository" (where the concept is just to read or view files on the home network) idea and not a "shared folder" (Where the concept is reads and writes are synced always and completely) idea?

#### June 12

    Hi Justin,

    Thank you for contacting Connected Data Support Center. This email is in regards to case number #324826 : Lack of responce..

    When it comes to the speed of the files being uploaded do you have it selected to have a local copy? One Thing we have been seeing is that when you have this selected the Transporters pushes the file transfer to the background which to not cause any drops in performance on your machine is not the fastest. If you can select that you have no local copy it will not push to the background and move the files right then and there. 
Yes there is a version two that has been announced. We don't have any data on this.  



    Kind regards,

    Connected Data Support
    Phone: 1-888-964-4607
    Mon - Fri (8am-8pm EST) Sat & Sun (9am-5pm EST)

----

    I am sorry, this needs to be a little more clear.  

    Here is my example:  http://cl.ly/image/2q0B1Z3y112o

    The top machine is an 2012 iMac with Local Copy enabled, this is the destination machine.  The bottom machine is a 2010 Mac Mini with Local Copy Enabled, this was the source machine.  BOTH machine lie idle for 90% of the day, with Gigabit ethernet connections.  This screenshot was taken 14 DAYS after I added this folder.

    Are you suggesting that 14 DAYS is not enough to transfer more than 5MB WITHIN NETWORK on two machines?

    On the Transporter website, I created the folder.  On MacMini, I enabled Local Copy and dropped in the iPhoto Library.  On the iMac I enabled Local Copy.   +After 14 DAYS, I see the folder is 5MB.

    I want to help, but I keep getting these vague "tech support" answers treating me like I'm retarded.  I'm not a user, I've written and contributed to many open-source projects,  give me to someone who can make changes or "has data on this" and I can help them track down bugs and perform diagnostics.

----

    Hi Justin,

    Thank you for contacting Connected Data Support Center. This email is in regards to case number #324826 : Lack of responce..

    Thats something we have noticed. Tho if your wanting to bypass the connected data software and make sure all your files are getting to the Transporter you can use SMB/CIFS. This would not only be the fast file transfer method but would insure file transfer. By default it is not enabled by default but you can enable it from the management page. For more information on SMB/CIFS please visit http://www.filetransporter.com/knowledgebase/?article=AA-00264



    Kind regards,


    Connected Data Support

    Phone: 1-888-964-4607
    Mon - Fri ( 8am-8pm EST) Sat & Sun ( 9am-5pm EST)

----


    I'm not really concerned my files are on the transporter, I'm concerned with my files being on the other computers.

    It is great to have a backup on the transporter, however, it is CRITICAL I have the files on the machines when I take the machines offline or to a remote location without internet access.

    Is this being addressed in v2.0?

----

    Hi Justin,

    Thank you for contacting Connected Data Support Center. This email is in regards to case number #324826 : Lack of responce..

     For more information on v2.0, if you can contact sales at 888-517-3786. 


    Kind regards,

    Connected Data Support
    Phone: 1-888-964-4607
    Mon - Fri ( 8am-8pm EST) Sat & Sun ( 9am-5pm EST)

#### June 14 

    I'm not interested in the new hardware.  Will there be new software to address this?

#### June 24

    Dear Justin,

    Sorry for the delayed response.  Has the Support agent requested a log file from you?  If not, please capture a log file while connected to your Transporter.  Instructions for this operation can be found at http://www.filetransporter.com/knowledgebase/?article=AA-00318.  It is also helpful if you can capture the log file close to the time of the error.

    Apologies again for the delayed response and thank you for your patience.

    Best regards,

    Bryan Wing
    Support Manager
    Connected Data, Inc.

----

    From IT manager to IT manager, at no point in time in the past TWO MONTHS, nor 6 emails have I had one diagnostic suggestion.

    Thank you for your concern.  I will attempt to grab a log file this evening.

    Can you answer a few questions regarding the following scenario?

    Two OSX machines are registered to a Connected Folder on a Transporter on the same network. Both machines have the "Local Copy" option checked.

    1) If I drop a file on Machine 1 into the Connected Folder, when can I expect it to appear on the Transporter?
    2) If I drop a file on Machine 1 into the Connected Folder, when can I expect it to appear on Machine 2?

    If I remove Machine 2 from the network, and update a file, then plug it back into the network.

    3) When can I expect it to appear on the Transporter?
    4) When can I expect it to appear on Machine 1?

    Thank you.

----

    Justin,

    If both Macs are on the same physical LAN (e.g. switch), you should be able to see your 'file' on both systems relatively quickly.  Reproduce your problem and capture a log file while connected to your Transporter and we'll attempt to sort out what the problem is from the data in the log file.  I didn't see which desktop software you are on, so please send that in too.  You will see the desktop version number in the same dialog box that you start the diagnostics.

    Thanks again for your patience.

    Best regards,

    Bryan Wing
    Support Manager
    Connected Data, Inc.

#### July 16

    Justin,


    I didn't see a response from you so I am resending the email I previously sent:

    If both Macs are on the same physical LAN (e.g. switch), you should be able to see your 'file' on both systems relatively quickly.  Reproduce your problem and capture a log file while connected to your Transporter and we'll attempt to sort out what the problem is from the data in the log file.  I didn't see which desktop software you are on, so please send that in too along with your Mac OS X version(s).  You will see the desktop version number in the same dialog box that you start the diagnostics.

    Thanks again for your patience.

    Best regards,

    Bryan Wing
    Support Manager
    Connected Data, Inc.

----

    Bryan,

    I thank you for your followup, but short of trying one or two files every few days, I have done nothing with the device as it continues to be unreliable.  The current version of software is nothing like Dropbox (which was my expectation) so I barely use it.

    I still do not understand "relatively quickly", and nobody at support will put a unit of measurement on it.  With Dropbox, I can see my file on my other system WITHIN SECONDS.

    If both Macs and the Transporter are on the same LAN and I drop a file on the Connected Data share on Mac01, how long will the file take to show on Mac02?
    a) "within a few seconds",
    b) "within 30 seconds",
    c) "under a minute"
    d) "longer than a minute"?

    There is a fundamental visual bug issue where Finder is not showing the proper size of the file or the file at all (which may be FUSE-related).[1]

    [1] https://forums.boxcryptor.com/topic/boxcryptor-for-mac-finder-needs-refresh-for-displaying-accurate-filenamesdirectories

#### July 18

    Justin,

    I used the term "relatively quickly" because we've found that it depends on how the router affects our management software.  Some router configs affect NAT traversal more than others.  For those who have port mapped get better results.  Our next release, 2.0 uses an additional method to obviate the need for port mapping in most cases.

    As far as file sizes, there is a bug in 1.x where the file sizes can be calculated incorrectly.  This is fixed in 2.0 also.

    I hope this answers your questions.

    Best regards,

    Bryan Wing
    Support Manager
    Connected Data, Inc.

