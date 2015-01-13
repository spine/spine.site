<% title 'Introduction' %>

Spine is a lightweight framework for building JavaScript web applications. Spine gives you an MVC structure and then gets out of your way, allowing you to concentrate on the fun stuff, building awesome web applications.

Spine is opinionated in its approach to web application architecture and design. Spine's architecture complements patterns such as de-coupled components and CommonJS modules, markedly helping with code quality and maintainability.

The library is written in [CoffeeScript](http://jashkenas.github.com/coffee-script), but doesn't necessarily require CoffeeScript to develop applications. You can use CoffeeScript or JavaScript, whichever language you're most familiar with.

Spine is tiny, the core library comes in at around 600 lines of CoffeeScript. Being lightweight and simple is fundamental to Spine, and it's only dependency is jquery or zepto.

##Core values

* *MVC* - The MVC pattern, or Model View Controller, is at the heart of Spine applications. It ensures your application is modular, name-spaced and doesn't descend into a mess of view and model logic by having a consistent architecture. It's great for teams, and brings a well needed structure to JavaScript development.

* *Asynchronous interfaces* - Too many JavaScript applications & frameworks don't take full advantage of the power of client-side rendering. End-users don't care if background requests to the server are pending, and don't want to see loading messages and spinners. Users want unblocked interfaces, and instant interaction. To enable this, Spine stores and renders everything client-side, communicating with the server asynchronously.

* *Simplicity* - Spine is a minimum possible viable product. It doesn't dictate your views, your HTML or your CSS. It is not a huge framework consisting of twenty different kinds of widgets. The goal is to get out your way; letting you go ahead and do what you do best, build awesome web applications.

##Why should you use Spine?

JavaScript frameworks are a dime a dozen, and more are appearing everyday. So what makes Spine so special?

* Built in a real-world environment
* Lightweight controller implementation (originally based on Backbone's API)
* Full model layer and ORM
* Ajax and HTML5 Local Storage adapters
* Asynchronous server communication
* Works in all major browsers (Chrome, Safari, Firefox, IE >= 9)
* Simple and lightweight
* minimal dependencies
* Very Approachable Source Code
* Great documentation

But don't take our word for it. Take a look at the source of the [example applications](<%= pages_path("examples") %>), and decide for yourself.

##Components

* *Spine* - The main library, containing the core classes, such as `Model` and `Controller`.

* *Extension Modules* - two way binding, routing, model relationship management etc. 

* *Spine Mobile* - Spine's mobile extension, letting you easily build [mobile and PhoneGap applications](<%= mobile_path %>) currently looking for a maintainer.

* *Spine.app* - The simple way of [generating Spine applications](<%= docs_path("app") %>).

* *Hem* - Spine's (optional but awesome) [dependency manager and development server](<%= docs_path("hem") %>).

##CoffeeScript

Spine is written in [CoffeeScript](http://jashkenas.github.com/coffee-script/), a little language that compiles into JavaScript. You don't have to write Spine applications in CoffeeScript, pure JavaScript will work fine. However, using CoffeeScript will be the path of least resistance, and the one we personally advocate.

CoffeeScript won't be everyone's cup of tea, and no doubt it'll turn some people off the framework. However, if you've qualms about the language, at least give it a chance and check it out; you should understand what you're missing. CoffeeScript has a lot to offer.

For an introduction to the language, see the [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/).

Spine's documentation caters for both JavaScript and CoffeeScript developers; you can toggle source code examples between the two languages using the silver handles: <button>»</button>

Alternatively, you can toggle the language site-wide by using the language selector in the top right of the documentation.

##Learning Spine

Spine itself is fairly straight-forward, as the library is small and the API minimal. However, it's the concepts behind JavaScript web applications that can be tricky to grasp at first. Moving state to the client-side, rendering on the client-side, and structuring your JavaScript using MVC and CommonJS modules can all be quite a learning curve.

It's for this reason, that Spine's docs read more like guides than raw API documentation, explaining the concepts and context to the solutions Spine brings. The pure API documentation [is also available](<%= api_path %>) once you're familiar with the library.

If you're new to Spine, you should first check out the four main guides:

1. [Classes](<%= docs_path("classes") %>)
1. [Models](<%= docs_path("models") %>)
1. [Controllers](<%= docs_path("controllers") %>)
1. [Views](<%= docs_path("views") %>)

Then you should experiment with the [getting started guide](<%= docs_path("started") %>), learning about [generating Spine apps](<%= docs_path("app") %>), and using [Hem](<%= docs_path("hem") %>).

Finally it is definitely recommended to browse [the source of spine itself](http://github.com/spine/spine) as well as the source of some example applications, such as the [Todos](http://github.com/maccman/spine.todos) and [Contacts](http://github.com/maccman/spine.contacts) apps.

##Companion guide

Spine was originally built alongside a book, [*JavaScript Web Applications*](http://oreilly.com/catalog/0636920018421) by O'Reilly. The book is a really good introduction to MVC, dependency management, templates and testing, all useful concepts whichever framework you end up using.

[![JavaScript Web Applications](http://covers.oreilly.com/images/0636920018421/cat.gif)](http://oreilly.com/catalog/0636920018421)
