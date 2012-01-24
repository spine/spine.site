<% title 'Views & Templating using jQuery.tmpl' %>

As JavaScript templating libraries go, you can't go far wrong with [jQuery.tmpl](https://github.com/jquery/jquery-tmpl). It's an official jQuery plugin, and the documentation is based on [jQuery's website](http://api.jquery.com/category/plugins/templates/). 

As well as having a straightforward syntax, the major advantage to jQuery.tmpl, above some of it's contemporaries, such as [Mustache](https://github.com/janl/mustache.js), is that you can retrieve the associated data from an element. In other words, if a click event is fired on a HTML element, you can retrieve the original record used to render the element. This is a really common scenario, which most of the templating libraries don't cater for. 

##Usage

The simplest way of using jQuery.tmpl is by [downloading the project](https://github.com/jquery/jquery-tmpl/zipball/master), and including `jquery.js` and `jquery.tmpl.js` as `<script>` tags in your application's head.
  
    <script src="jquery.js" type="text/javascript" charset="utf-8"></script>
    <script src="jquery.tmpl.js" type="text/javascript" charset="utf-8"></script>

##jQuery.tmpl syntax

The syntax is fairly straightforward, only consisting of a couple of templating tags, `{{}}` and `${}`. For example:

    {{if messages.length}}
      <ul>
        {{each messages}}
          <li>${$index + 1}: <em>${$value.url}</em></li>
        {{/each}}
      </ul>
    {{else}}
      <p>Sorry, there are no messages</p>
    {{/if}}

The full list of template tags is as follows:

* `${url}`
  Evaluate a JavaScript expression in the current context, printing its escaped return value.
  
* `{{html body}}`
  Evaluate a JavaScript expression in the current content, printing its unescaped return value.
  
* `{{if url}} ${url} {{/if}}`
  Control template flow using the `if` statement.
  
* `{{if url}} ${url} {{else}} <span>No URL</span> {{/if}}`
  Control template flow using the `else` statement.

* `{{each messages}} <li>${$index + 1}: <em>${$value}</em></li> {{/each}}`
  Iterate over an expression. `$index` refers to the current index, whilst `$value` refers to the current iterated item.

Templates are evaluated within a context, such as a model instance. This context is passed to the template renderer.

##Rendering templates

jQuery.tmpl templates can be stored as inline custom script tags inside your application's HTML.

    <script id="itemTemplate" type="text/x-jquery-tmpl">
      <li>${name}</li>
    </script>
    
The advantage of custom script tags, is that the browser just interprets them as plain text, and doesn't try to interpret their contents. This helps will performance, especially with the initial page rendering.

You can then render the template using `$.fn.tmpl()`, passing in the template context. 
    
    //= CoffeeScript
    $( "#itemTemplate" ).tmpl( Contact.all() )
    
`$.fn.tmpl()` returns a jQuery element instance that you can just use as you would any other jQuery object. In the example below, we're replacing the HTML of the controller's element (`el`) with the rendered template.

    //= CoffeeScript
    class Contacts extends Spine.Controller
      render: ->
        @html $( "#itemTemplate" ).tmpl( Contact.all() )

    //= JavaScript
    var Contacts = Spine.Controller.sub({
      render: function(){
        var template = $( "#itemTemplate" ).tmpl( Contact.all() );
        this.html( template );
      }
    });
    
If you pass an array to `$.fn.tmpl()`, as in the above example, the library will iterate over the array, rendering each item and returning the combined result. 

The first time you call `$.fn.tmpl()`, the template is compiled and then rendered. For subsequent calls, the compiled template will be cached, speeding up the whole process. 

##Data association

As I mentioned in this guide's introduction, rendered template elements are associated with the original data used to render them. We can fetch the associated data using `$.fn.tmplItem()`, like so:

    //= CoffeeScript
    contact = $("items:first").tmplItem().data
    
Spine provides a shortcut for this, in [*tmpl.js*](https://raw.github.com/maccman/spine/master/lib/tmpl.js). This defines a function called `$.fn.item()` on jQuery instances.

    //= CoffeeScript
    contact = $("items:first").item()
    
You can see the real power of data association when it comes to controllers. For example, let's say we have a list of rendered contacts, and we're listening to *click* events on them. 
    
    //= CoffeeScript
    class Contacts extends Spine.Controller
      events: "click .item": "click"
      
      render: ->
        @html $( "#itemTemplate" ).tmpl( Contact.all() )
        
      click: (e) ->
        contact = $(e.target).item()
        # Do stuff with the contact

    //= JavaScript
    var Contacts = Spine.Controller.sub({
      events: {"click .item": "click"},
      
      render: function(){
        var template = $( "#itemTemplate" ).tmpl( Contact.all() );
        this.html( template );
      },
      
      click: function(e){
        var contact = $(e.target).item();
        // Do stuff with the contact
      }
    });
    
When an `.item` is clicked, the `click()` callback is invoked, and through data association we can find out which record the click was referring to. 

##Binding

Data binding is a very powerful technique for ensuring model data stays in sync with the view. The premise is that controllers bind to model events, re-rendering the view when those events are triggered. Let's take a simple example, a list of contacts. The controller will bind to the `Contact` model's *refresh* and *change* events, which are triggered whenever the model's data changes. When the event is triggered, the controller re-renders the view.

    //= CoffeeScript
    class ContactsList extends Spine.Controller
      constructor: ->
        Contact.bind('refresh change', @render)
        
      render: =>
        items = Contact.all()
        @html require('views/contacts')(items)
    
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      init: function(){
        Contact.bind('refresh change', this.proxy(this.render));
      },
      
      render: function(){
        var template = $( "#itemTemplate" ).tmpl( Contact.all() );
        this.html( template );
      }
    });

There are several common binding patterns, see the [controller patterns guide](<%= docs_path("controller_patterns") %>) for more information.

##Bundling templates

Often it's useful to use some sort of dependency management system to bundle templates with your application, rather than fill up your app's HTML with endless custom script tags. Luckily, there a few server options that will automatically bundle up templates for you.

If you're developing your Spine app with [Hem](<%= docs_url("hem") %>) then you've already got jQuery.tmpl support, simply name views with an extension of `.tmpl`, and they'll automatically be compiled as templates and included in your application. Remember to include the `jquery.tmpl` npm module as a dependency in your application's `package.json` file, and also in the `slug.json` file.

If you're using Rails and Sprockets, then the [sprockets-jquery-tmpl](https://github.com/rdy/sprockets-jquery-tmpl) will automatically add any jQuery.tmpl templates with `.tmpl` extensions to the asset pipeline. You'll also need to include the library using a pre-processor comment:

    # application.coffee
    #= require jquery
    #= require jquery.tmpl
