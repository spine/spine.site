<%- title 'Introduction' %>

Spine Mobile is a lightweight framework on top of Spine for building mobile JavaScript web applications. What makes Spine Mobile stand out from the competition is attention to detail. User experience comes before all else, and Spine Mobile applications strive for a native feel; they shouldn't give a discernibly different feel than applications built in Objective C or Java.

So what's the motivation behind building this framework, surely developers should just learn native technologies? Well, I think there's a number of compelling reasons, such as exposing mobile applications to more developers, cross platform porting, and ease of development. Technologies such as HTML & CSS were designed for developing interfaces, and they're absolutely fantastic at doing so. There's no technological reason why HTML apps can't give as good or better an experience than native technologies. 

##Features

* Specialized controllers and panel layout
* Hardware accelerated transitions
* Touch events

##Examples

[currency.io](http://currency.io) has been ported to a Spine Mobile application. You can find the source for it [here on GitHub](https://github.com/maccman/spine.mobile.currency), and see a live demo on [Heroku](http://spine-mobile-currency.herokuapp.com). The live demo is best viewed on a iOS 5.0 device. 

[![Currency](https://lh5.googleusercontent.com/-hcwujJAkdVU/TnYhDQ5VoZI/AAAAAAAABYA/pRrKwNoNccc/s400/Screen%252520Shot%2525202011-09-18%252520at%25252017.27.50.png)](https://github.com/maccman/spine.mobile.currency)

##Installation

The most straightforward way of building Spine Mobile apps is with [Hem](<%= docs_path("hem") %>), [Spine.app](<%= docs_path("app") %>), [GFX](http://maccman.github.com/gfx) and [jQuery](http://jquery.com). The first step, is to install all the required npm modules. 

If you haven't got them installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Then, to install:

    npm install -g spine spine.app hem
    
Spine.app will generate an initial project structure for you, with the `mobile` generator:

    spine mobile ./myapp
    
Now, `cd` into your project directory, and install the local npm modules:
    
    cd ./myapp
    npm install .
    
Right - now we're good to go. Let's start up the Hem server:
    
    hem server
    
And browse [to our application](http://localhost:9294). For more information about [Spine.app](<%= docs_path("app") %>) or [Hem](<%= docs_path("hem") %>), see their respective guides. 

##Next steps

Now you've got Spine Mobile all setup, it's time to start learning more about the framework. You should start by reading the [Controllers](<%= mobile_path("controllers") %>), [Transitions](<%= mobile_path("transitions") %>) and [Events](<%= mobile_path("events") %>) guides, as well as looking at the [example applications](https://github.com/maccman/spine.mobile.currency).