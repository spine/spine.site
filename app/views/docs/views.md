<% title 'Views & Templating' %>

In Spine's terminology, views are simple fragments of HTML that make up the interface to your application. Spine doesn't have any complex UI widgets or dictate the structure of your views, they're completely up to you. 

To ensure your application's interface is completely asynchronous and responsive, you should be doing **all** the view rendering client-side. This means instead of server-side templates, like Ruby's ERB or Python’s string formatting, we're going to need client-side JavaScript templates.

There are a number of good candidates, such as [Mustache](http://mustache.github.com) and [Jade](http://jade-lang.com/). We're going to demonstrate a library called [Eco](https://github.com/sstephenson/eco) here.

Besides Eco, Jade is the other template solution that is built into Hem. For info on using jade with a spine app see the [Jade guide](<%= docs_path("views_jade") %>).

##Eco templates

JavaScript templates are very similar to server side ones. You have template tags interoperated with HTML, and during rendering those tags get evaluated and replaced. The great thing about [Eco](https://github.com/sstephenson/eco) templates, is they're actually written in CoffeeScript, a language you should be familiar with if you've been developing Spine applications. 

Here's an example:

    <%% if @projects.length: %>
      <%% for project in @projects: %>
        <a href="<%%= project.url %>"><%%= project.name %></a>
        <p><%%= project.description %></p>
      <%% end %>
    <%% else: %>
      No projects
    <%% end %>

As you can see, the syntax is remarkably straightforward. Just use `<%%` tags for evaluating expressions, and `<%=` tags for printing them. The full list of template tags is as follows:
    
* `<% expression %>`  
  Evaluate a CoffeeScript expression without printing its return value.

* `<%%= expression %>`  
  Evaluate a CoffeeScript expression, escape its return value, and print it.

* `<%%- expression %>`  
  Evaluate a CoffeeScript expression and print its return value without escaping it.

* `<%%= @property %>`  
  Print the escaped value of the property property from the context object passed to render.

* `<%%= @helper() %>`  
  Call the helper method helper from the context object passed to render, then print its escaped return value.

* `<%% @helper -> %>...<%% end %>`  
  Call the helper method helper with a function as its first argument. When invoked, the function will capture and return the content ... inside the tag.
  
Templates are evaluated with a context, such as a model instance. CoffeeScript's `@` symbol, i.e. `this`, points to the context. 

##Compiling templates

Eco lets you compile templates dynamically in the browser, or pre-compile them using Node. I advise the latter, as pre-processing is a one-off process that saves your clients some processing time. 

[Hem](<%= docs_path("hem") %>) actually comes with built in support for pre-compiling eco templates, it's simply a case of naming views with a `.eco` extension. They're wrapped up automatically with the rest of your application as functions, and can be used by just calling them:
    
    render: ->
      @html require("app/views/contact")(@contact)
      
As you can see in the example above, we're just requiring the view, then calling it immediately, passing in the relevant context (in this case, a model record). 

Calling the view returns the rendered template as a string, which we're passing straight to the `@html()` function, updating the controller's `@el` element.

##Data association

Eco templates deal entirely with strings, so it isn't possible to associate a template HTML element, with an object. For example, it isn't possible to render a list of records with Eco templates, listen to click events on them, and then associate those click events with the original records. Unfortunately, this is a fairly common scenario in web applications. 

Luckily Hem comes to the rescue with `.jeco` templates. If you give view templates a `.jeco` extension, instead of `.eco`, they'll be wrapped in a jQuery selector which associates the element with the data. 

    # app/views/contacts.jeco
    <div class="item"><%= @name %></div>
    
    # app/controllers/contacts.coffee
    class Contacts extends Spine.Controller
      events: 'click .item': 'clicked'

      render: ->
        items = Contact.all()
        @html @require('views/contacts')(items)
        
      clicked: (e) ->
        element = $(e.target)
        item = element.data('item')
        @log "Contact #{item.name} was clicked"

As you can see in the `clicked()` callback, we're taking the event object `e`, finding the `element` it's associated with, and then finding the record associated  with that element, `item`. Spine provides a shortcut for this, in `spine/lib/tmpl`:

    # app/controllers/contacts.coffee
    require('spine/lib/tmpl')
    class Contacts extends Spine.Controller
      clicked: (e) ->
        item = $(e.target).item()
        @log "Contact #{item.name} was clicked"
        
The `tmpl.coffee` utility gives jQuery objects the `$.fn.item()` function, which will return the element's associated data. 

`.jeco` templates also have the advantage that you can give them an array to render, and they'll automatically iterate over it. 

##Template helpers

Template helpers are extremely useful for view specific logic, without violating MVC by putting lots of code in the view. Template helpers should exist as properties on the controller. Helpers can then be called by passing an instance of the controller to the template when rendering it. 

For example, let's take the Currencies controller from the [sample Currency app](https://github.com/maccman/spine.mobile.currency). We need to format the `@output` and `@input` numbers a comma every three digits for legibility. This is the perfect scenario for a helper:

    class Currencies extends Spine.Controller
      render: ->
        @output = @input and (@input * @rate()).toFixed(2) or 0
        @html require('views/currency')(@)
        
        helper:
          format: (num) ->
            num.toString().replace(/\B(?=(?:\d{3})+(?!\d))/g, ",")

Inside the template we can call the helper, passing in the appropriate variables:
    
    <section class="input">
      <h1><%%= @helper.format(@input) %></h1>
      <h1><%%= @helper.format(@output) %></h1>
    </section>
    
Simple and clean!

##Binding

Data binding is a very powerful technique for ensuring model data stays in sync with the view. The premise is that controllers bind to model events, re-rendering the view when those events are triggered. Let's take a simple example, a list of contacts. The controller will bind to the `Contact` model's *refresh* and *change* events, which are triggered whenever the model's data changes. When the event is triggered, the controller re-renders the view.

    class ContactsList extends Spine.Controller
      constructor: ->
        Contact.bind('refresh change', @render)
        
      render: =>
        items = Contact.all()
        @html require('views/contacts')(items)
        
Notice we're using a 'fat arrow' for the `render()` function. This ensures that `render()` is invoked in the correct context of `ContactsList`, rather than `Contact`. For more information on function binding, see the [classes guide](<%= docs_path("classes") %>).

There are several common binding patterns, see the [controller patterns guide](<%= docs_path("controller_patterns") %>) for more information.
