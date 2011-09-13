<% title 'Views & Templating' %>

In Spine's terminology, views are simple fragments of HTML that make up the interface to your application. Spine doesn't have any complex UI widgets or dictate the structure of your views, they're completely up to you. 

To ensure your application's interface is completely asynchronous and responsive, you should be doing **all** the view rendering client-side. This means instead of server-side templates, like Ruby's ERB or Python’s string formatting, we're going to need client-side JavaScript templates.

There are a number of good candidates, such as [Mustache](http://mustache.github.com) and [jQuery.tmpl](http://api.jquery.com/category/plugins/templates). We're going to demonstrate a library called [Eco](https://github.com/sstephenson/eco) here.

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
    
* `<%% expression %>`  
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

[Hem](<%= docs_path("hem") %>) actually comes with built in support for pre-compiling eco templates, it's simply a case of naming views with a `.eco` extension. 

    require("app/views")()

##Data association



##Template Helpers

##Binding


[Templating](<%= docs_path("templating") %>)