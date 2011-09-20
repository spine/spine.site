
WebKit on iOS, and indeed on other platforms such as Android, has some custom meta tags to alter its behavior for mobile apps. This guide will give you an overview of the main tags, but see [Apple's documentation](http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/Introduction/Introduction.html#//apple_ref/doc/uid/TP40002079-SW1) for the full details.

##Viewport

By default, Mobile Safari assumes a page has been designed for the desktop, and will scale the viewport accordingly. This lets users double tap, or pinch to zoom the page, useful for most websites, but for not applications. We want our application to display as-is, without any scaling or zooming. To do this, is just a matter of including the following meta tag in the page's head:

    <meta name="viewport" content="width=device-width; initial-scale=1.0; minimum-scale=1; maximum-scale=1.0; user-scalable=0;"/>

This disables the zooming, and locks the scale at 1.0. For more information, see the [Apple Developer guide](http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/UsingtheViewport/UsingtheViewport.html#//apple_ref/doc/uid/TP40006509-SW1). 
        
##Making an application


    <meta name="apple-mobile-web-app-capable" content="yes" />

##Specifying an icon

    <link rel="apple-touch-icon-precomposed" href="images/icons/appicon.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="images/icons/appicon-x2.png">
    
##Specifying a startup image

    <link rel="apple-touch-startup-image" href="images/loading.png">

##Changing the Status Bar Appearance

    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    