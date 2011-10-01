<% title 'Stage & Panel Controllers' %>

A stage is just a [Spine controller](<%= docs_path("controllers") %>), which generates a few elements, has some transition support, and an internal panel [manager](<%= docs_path("manager") %>). Panels are similar, but have slightly different transitions. Stages contain multiple Panels. 

Stages usually cover the whole viewport (i.e. the whole screen), whilst Panels only cover the application's header and content. Usually, an application displays only one Stage and Panel at a time. The application's Panels then transition in and out to show the user different part of the application. 

##Stage

A stage consists of three elements, a `header`, an `article` and a `footer`. It looks like this:
    
    <body class="stage">
      <header></header>
      <article class="viewport"></article>
      <footer></footer>
    </body>
    
Spine Mobile includes some default CSS, which does the following:

* Set's the document's body width and height to 100% 
* `header` is absolutely positioned at the top of the stage
* `footer` is absolutely positioned at the bottom of the stage
* `article` is absolutely positioned at the absolute top and bottom of the stage

The Stage layout is better demonstrated by this diagram:

![Stage](https://lh3.googleusercontent.com/-R5HgKL4wur0/TnYhHvxKsZI/AAAAAAAABYE/-VErIKpG4iw/s640/Screen%252520Shot%2525202011-09-18%252520at%25252016.59.51.png)

Now, you have have noticed something unusual here. The `article` (i.e. Stage content) stretches over the `header` element. This is because the Stage's `header` **is blank**. It's purely there for decorative purposes, and contains no content. It's the Panel's `header` that contains text and buttons. This is all because of transition support, which we'll cover later.

Every application is setup by creating a Global Stage, which all your application's panels will be added to. It is usually is set on the `body` element.

    class App extends Stage.Global
      constructor: ->
        super
        
        # Instantiate panels
        @contacts = new Contacts
        
    jQuery ->
      app = new App(el: $('body'))
      
In the example above, the Global Stage is being instantiated when the page loads. Subsequent to that, its constructor starts instantiating our application's panels.

##Panel

A Panel consist of two elements, a `header` and an `article`. Like a Stage, a Panel is just a specialized Spine controller with some transition support whenever the Panel is activated or deactivated. Usually only one Panel is shown at any one time in your application. A Panel could contain a list of contacts, a form to be completed, or a login page. The basic generated markup looks like this:

    <div class="panel">
      <header></header>
      <article></article>
    </div>

Spine includes some default styling of panels too, which stretches the content to fill any remaining space. Visually, it looks like this:
    
![Panel](https://lh3.googleusercontent.com/-rXkOzzQQd2o/TnYb9GAk1cI/AAAAAAAABXo/qsXSujwc_2I/s640/Screen%252520Shot%2525202011-09-18%252520at%25252017.10.43.png)

Note the fact the Panel's `header` covers the Stage's `header`. The Stage's header contains the background gradient, whilst the Panel's header contains buttons, and the Panel's title. The Panel's header can't contain a background color, as this would mess with the fading transitions. Instead, the Stage's `header` contains the background, and the Panel's `header` contains the content.

As soon as a Panel is instantiated, it's added to the Global Stage. Behind the scenes, this means the Panel is appended to the Global Stage's `article` div, and added to the Global Stage's [manager](<%= docs_path("manager") %>). Let's look at an example:
    
    class ContactsList extends Panel
      constructor: ->
        super
        Contact.bind('refresh change', @render)

      render: =>
        items = Contact.all()
        @html require('views/contacts/item')(items)

    class App extends Stage.Global
      constructor: ->
        super

        # Instantiate panels
        @contacts = new ContactsList
        
        # Activate a panel
        @contacts.active()
        
    jQuery ->
      app = new App(el: $('body'))
      
As you can see, when the `App` Stage is instantiated, it in turn instantiates the `ContactsList` Panel. So far so good. The Panel then sets up some event handlers on a `Contact` model, and a basic render function. Once the Panel has been instantiated, it's then activated, with the `active()` function. This deactivates any other Panels the Stage may have, and activates the `ContactsList` panel, showing it to the user. 

##Panel properties
    
Spine Mobile includes some helper methods for setting the title on Panels, and adding buttons, the `title` and `addButton` properties. If the `title` instance property exists, then the Panel controller will create a `<h2>` element in the `header`, containing the Panel's title. Likewise, calling `addButton(name, callback)`, add's a `<button>` to the header. For example:

    class ContactsList extends Panel
      title: 'Contacts'
      
      constructor: ->
        super
        @addButton('New', @new)
        Contact.bind('refresh change', @render)

      render: =>
        items = Contact.all()
        @html require('views/contacts/item')(items)
        
      new: ->
        # ...
        
The controller above generates the following markup:
        
    <div class="panel">
      <header>
        <button>New</button>
        <h2>Contacts</h2>
      </header>
      <article></article>
    </div>
    
##Theming

Theming your application is up to you. Spine provides a default theme which fits in with the general look and feel of iOS, but feel free to experiment. Having said that, read Apple's [Human Interface Guidelines](http://developer.apple.com/library/mac/#documentation/UserExperience/Conceptual/AppleHIGuidelines/Intro/Intro.html), especially if you're submitting your app to the App Store using PhoneGap. 

Make sure your application layout is fluid. There are a [huge number](https://gist.github.com/1232164) of iOS screen sizes your app needs to support, and don't get me started on Android. 
    
##Next steps

So we've got the basic building blocks for our application, Stages and Panels. Everything we subsequently cover will build of those. Now, let's look at [transitioning between Panels](<%= mobile_path("transitions") %>).

