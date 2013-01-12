---
layout: note
title: Eye-Fi Slideshow
excerpt: I have read many posts trying to create a slideshow of latest pictures for weddings, birthdays, funerals, etc from people with a Eye-Fi card in their camera. None of them have done it right, this is my attempt, and it works better than the others.  
promote: true
published: true
last_modified: 2013-01-10 00:00:00 +0000
---
Like thousands of people before me, I just received my new Eye-Fi card and wanted to see my latest pictures up on the screen. 

I first attempted to use [AppleScript within Automator](http://apple.stackexchange.com/questions/24961/an-app-or-script-to-watch-folder-and-display-new-images-in-full-screen) and make it a Folder Action.  Unfortunately, I could not tell what the current state was, whether QuickLook was open or full screen.  Since each key press (```command-option-y```) enabled as well as disabled full-screen, as each picture was added, the first would enter full screen, the next picture would disable it.

So, desperate, tired, beaten, I turned to Quartz Composer.

#### 8 Hours in a Different Paradigm

"What the hell is that?", I hear you say.  Well, I am clearly the last person on Earth that wrote something for it, as it is nearly a dead language.

I have many programming and scripting languages under my belt.  I am by no means an expert in some of them, but most of them I can hack it to something useful given some time and a desire. This skill would help me immensely in the next eight hours.

I was LOST. My programming mindset is much like the advice from King of Wonderland, "_Begin at the beginning and go on till you come to the end: then stop_", but when I opened up Quartz, there was beginning, no start, and no end!  Where are the loops, the conditionals, the functions, oh my?!

#### The Good

Boom! The program does what it is supposed to. It will display the last _x_ pictures in any subdirectory, and loop the slide show based on a custom duration.  As you add new pictures, the older ones play faster, the newer ones stay up longer.

<img src="https://dl.dropbox.com/u/186154/slideshowsample.png">

<img src="https://dl.dropbox.com/u/186154/slideshow.png">

#### The Bad

There are a number of problems with this, mostly due to my limited experience (a total of 8 hours, in one day) with Quartz Composer.

 1. It requires a minimum number of two (2) pictures in the directory.  The way I check and set the "Scan Signal", if you have less than two (2) pictures in the directory, it never properly toggles, and thus never re-scans.
 2. It requires a minimum of two (2) pictures to rotate. The way I check and set the "Scan Signal", if you have less than two (2) pictures set in the options for "Show Last X Pictures", it never properly toggles, and thus never re-scans.
 3. The last _x_ pictures are counted by NAME. This is made for cameras dumping images in the directory, therefore, it is expecting new files to be added to the end of the sequence (e.g. ```IMG_0001.jpg``` is added, then ```IMG_0002.jpg``` is added, etc). If you add new files out of sequence, (e.g. adding in ```IMG_0000.jpg``` after ```IMG_0002.jpg```), the count becomes incorrect.

#### The Ugly

Your mom.

#### Download

[https://github.com/jnovack/slideshow](https://github.com/jnovack/slideshow)

#### Install

 1. Copy ```Slideshow``` to ```~/Library/Screen Savers/```
 2. Enter *System Preferences*
 3. Select the *Recent Pictures Slideshow*
 4. Update the Screen Saver Options
 5. Run your screensaver.

#### Options

 * Display_Name: Do you want to show the image name in the bottom right corner?
 * Directory: Set your pictures directory, defaulted to ```~/Pictures/```
 * Duration: In seconds, of the slideshow.  The more pictures you are showing, I recommend a longer rotation time.
 * Show Last _x_ Pictures:  How many pictures do you rotate? (minimum two (2))

#### References

 1. [http://apple.stackexchange.com/questions/24961/an-app-or-script-to-watch-folder-and-display-new-images-in-full-screen](http://apple.stackexchange.com/questions/24961/an-app-or-script-to-watch-folder-and-display-new-images-in-full-screen)
 2. [http://www.apertureexpert.com/tips/2012/5/17/creating-an-auto-refreshing-slideshow-from-eye-fi-upload.html](http://www.apertureexpert.com/tips/2012/5/17/creating-an-auto-refreshing-slideshow-from-eye-fi-upload.html)
 3. [http://vimeo.com/8804233](http://vimeo.com/8804233)

