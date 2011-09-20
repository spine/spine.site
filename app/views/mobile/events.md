<% title 'Events' %>

Although mobile browsers, such as Mobile Safari, have many of the same events as we're used to in desktop browsers, there are a few key differences. Not being fully aware of these differences, could give your application a sluggish feel, even though you optimized everything else. It's worth getting right. 

##300ms click event

One classic mistake mobile developer make, is using the *click* event. That's right: **don't use the click event**. Mobile Safari waits 300ms after the initial touch has ended before firing the *click* event. This is because the browser doesn't know if it should fire a *click* or a *dblclick* event, it just waits a while to see if there's a recurring touch. This 300ms delay is definitely discernible by your users, and leads to a terrible experience. Don't use the *click* event.

##tap

Instead, Spine provides a custom alternative, the *tap* event. This fires as soon as the user lifts their finger from the element, and will provide a much more responsive interface than the *click* event. 

Using *tap* is straightforward. Simple replaces usage of *click* with the event. For example:

    class ContactsList extends Panel
      # Replace 'click' with 'tap'
      events:
        'tap .item': 'select'

      select: (e) ->
        item = $(e.target).item()
        @navigate('/contacts', item.id, trans: 'right')
        
In browsers that don't support touch events, Spine will fire *tap* events when the user clicks on an element. In other words, it's backwards compatible with non-touch enabled browsers. 

The event won't fire if the user moves their finger, as that should be interpreted as either a scroll, or a swipe gesture. 

##Orientation events

Most mobile browsers, such as Mobile Safari, will fire an *orientationchange* event when the phone changes orientation. This is especially useful, if you want to lock the UI in a certain direction. Unless you're using [PhoneGap](<%= mobile_path("phonegap") %>), you can't lock the orientation at the browser level, but you can disable the UI. 

Say you designed an iOS application to be only viewed in portrait, you could lock the orientation like so:

First, add a class indicating the orientation to the document's body:

    $('body').bind 'orientationchange', (e) ->
      orientation = if Math.abs(window.orientation) is 90 then 'landscape' else 'portrait'
      $('body').removeClass('portrait landscape')
               .addClass(orientation)
               .trigger('turn', orientation: orientation)

Then, using a pseudo element, we can block the UI when the application is in the landscape orientation.

     body.landscape::after {
       position: absolute;
       left: 0;
       right: 0;
       top: 0;
       bottom: 0;
       padding: 15%;
       content: "Portrait only mode supported";
       text-align: center;
       font-size: 16px;
       background: rgba(255, 255, 255, 0.9);
     }
     
If the *orientationchange* event is too basic for your needs, consider the *devicemotion* event. This gives you a much deeper integration with the accelerometer, allowing you to create custom events, like the [*shake* event](https://gist.github.com/1226477).

##Touch events

Touch events and gestures are a pretty big area, and whilst we've covered some of it here, there's still much to learn. I'd like to point you to [Apple's own documentation](http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html#//apple_ref/doc/uid/TP40006511-SW1) concerning this area, as it's pretty comprehensive.