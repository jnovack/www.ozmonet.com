---
layout: post
title: Tweaking the Bootstrap Carousel
excerpt: I needed a way to jump to a specific image in the bootstrap carousel rather than always showing the first image upon page load.
tags: [jquery, bootstrap]
categories: [code]
last_updated: 2013-01-08
---
While playing with the [Bootstrap carousel](http://twitter.github.com/bootstrap/javascript.html#carousel) javascript on my [photography page](/photography/), it immediately seemed stale.  While I like the first image, I wanted to use a hash in the url to allow hotlinking to a specific image.

This one took quite a bit of Google searching as not many people have done this, additionally it is my first time playing with hashes in the url, and bootstrap carousel.

<!--break-->

##### Finding the Active Item

First, I found the currently displayed image has a div class of `active`. Of note, the carousel does not care which is active at any time, it will always act accordingly (_my fear was that there was some sort of internal counter and I could not programatically change the "active" picture without futzing something up.  When you have worked with as many programming languages and deciphered as much hack code as I have, you would understand why I was worried_).  Suffice to say this was the easy part.  Simply call `.removeClass('active')` on the current active item.

```javascript
    $('#my-carousel-id .carousel-inner .item.active').removeClass('active');
```

##### Setting the Active Item

My method for which image to activate was easy, passing a 4 would activate the 4th image. This made it possible to use the jquery `nth-child` selector.  Once I had the index I wanted to activate, it was as simple calling `.addClass('active')` to show it.

```javascript
    $('#my-carousel-id .carousel-inner div:nth-child(' + url.split('#')[1] + ')').addClass('active');
```
You can make this as complicated as you need to as long as your HTML structure supports it, but I did not have that desire.  If you would like to activate based on id, then you would need to set an id for each div item.

You will notice that I am using the `url.split` method of finding the hash, I could have easily used `window.location.hash` to get the information, but I did not want to then have to parse out the `#` (which comes with `window.location.hash`).

##### Updating the URL

Finally, I now need to update the location bar based upon any movement made in the carousel.  When I change the picture, I want the location url (and hash) to change as well, this way I can find the picture I want, and copy the URL to send.

Normally, I would just bind to the `onmouseover`, or `click` events, but this was the carousel, which can move on its own!  I did not solve this one myself, but with the help of a [stackoverflow post](http://stackoverflow.com/questions/10499154/bootstrap-carousel-number-active-icon).  The event which is triggered upon completion of the carousel move (whether via prev-next click or automatic advancing) is `slid`.  You can bind on that event, and run your own function.

```javascript
    $('#my-carousel-id').bind('slid', function() { alert('Hot potatoe!'); });
```

Earlier, I mentioned `window.location.hash`.  Good news!  This is WRITABLE. Upon binding to the `slid` event, I just found the current `nth-child` index and wrote the hash back.  Be mindful that the `.index()` is 0-based (starts counting from 0), but `nth-child` (which is used to set the active picture, above) is 1-based (starts counting from 1).  Therefore, we parse the index as an integer and add one (1) to it before writing the hash.

```javascript
    window.location.hash = "#"+ parseInt($('#my-carousel-id .carousel-inner .item.active').index()+1);
```

#### Code

```javascript
var url = document.location.toString();
if (url.match('#')) {
    // Clear active item
    $('#my-carousel-id .carousel-inner .item.active').removeClass('active');

    // Activate item number #hash
    $('.carousel-inner div:nth-child(' + url.split('#')[1] + ')').addClass('active');
}

$('#my-carousel-id').bind('slid', function (e) {
    // Update location based on slide (index is 0-based)
    window.location.hash = "#"+ parseInt($('#my-carousel-id .carousel-inner .item.active').index()+1);
});
```

#### Demonstration

Just checkout my [photography page](/photography/).  This will hot link directly to [my favorite ornament](/photography/#3).

#### References

1. [http://stackoverflow.com/questions/10499154/bootstrap-carousel-number-active-icon](http://stackoverflow.com/questions/10499154/bootstrap-carousel-number-active-icon)
