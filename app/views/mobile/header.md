<% title 'Header Tags' %>

WebKit on iOS, and indeed on other platforms such as Android, has some custom meta tags to alter its behavior for mobile apps. This guide will give you an overview of the main tags, but see [Apple's documentation](http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/Introduction/Introduction.html#//apple_ref/doc/uid/TP40002079-SW1) for the full details, or Mathias Bynens' [excellent guide](http://mathiasbynens.be/notes/touch-icons).

##Viewport

By default, Mobile Safari assumes a page has been designed for the desktop, and will scale the viewport accordingly. This lets users double tap, or pinch to zoom the page, useful for most websites, but for not applications. We want our application to display as-is, without any scaling or zooming. To do this, is just a matter of including the following meta tag in the page's head:

    <meta name="viewport" content="width=device-width; initial-scale=1.0; minimum-scale=1; maximum-scale=1.0; user-scalable=0;"/>

This disables the zooming, and locks the scale at 1.0. For more information, see the [Apple Developer guide](http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html#//apple_ref/doc/uid/TP40006509-SW1). 
        
##Making an application

Mobile Safari gives you the ability to turn a site into what's looks like a native app, which launches without any browser chrome. 

    <meta name="apple-mobile-web-app-capable" content="yes" />

Enabling it gives you the following option in Safari.

![Add to home screen](https://lh6.googleusercontent.com/-1SdIt9Q2m8w/Tnhpr1L2r5I/AAAAAAAABYY/TILnotS54P0/s400/Screen%252520Shot%2525202011-09-20%252520at%25252011.22.26.png)

##Specifying an icon

To specify an icon for the application, you can use the link tag `apple-touch-icon`. It should point to an image sized 57 x 57 px.

    <link rel="apple-touch-icon" href="images/icons/appicon.png">
    
Otherwise, iOS will just use a screenshot of the application.

![Icon](https://lh3.googleusercontent.com/-67tNvZmlhmw/TnhuBy13kFI/AAAAAAAABYs/HEyJdo9LDAk/s400/Screen%252520Shot%2525202011-09-20%252520at%25252011.41.51.png)

The alternative is to use the `apple-touch-icon-precomposed` link tag which will stop iOS adding any effects to the icon.

You should also provide a high resolution version of your icon for Retina displays. This should be double the size (114 × 114)

    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/icons/appicon-x2.png">
    
##Specifying a startup image

To specify a startup image for the application, use the link tag `apple-touch-startup-image`. 

    <link rel="apple-touch-startup-image" href="images/loading.png">
    
This is highly recommended, as otherwise your users just get to stare at a blank screen for a couple of seconds. One approach to this, is using a [slightly transparent](https://lh5.googleusercontent.com/-J_xuBNnOLCw/Tnh3arQioDI/AAAAAAAABZA/TFF9YWismM8/s800/loading.png) png, which will display the application's interface, but be obvious to the user that it's temporarily disabled. 

##Changing the Status Bar Appearance

You can set the appearence of the status bar in your application, to fit with your design, by using the `apple-mobile-web-app-status-bar-style` meta tag. 

    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    
![Status bar](https://lh4.googleusercontent.com/-AA5WRYDjaxY/Tnh4iEWzBEI/AAAAAAAABZQ/JEe-HHeXD2U/s400/Screen%252520Shot%2525202011-09-20%252520at%25252012.25.54.png)

The supported values for this are:

* default
* black
* black-translucent
