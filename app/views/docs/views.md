<% title 'Views & Templating' %>

In Spine's terminology, views are simple fragments of HTML that make up the interface to your application. Spine doesn't have any complex UI widgets or dictate the structure of your views, they're completely up to you. 

To ensure your application's interface is completely asynchronous and responsive, you should be doing **all** the view rendering client-side. This means instead of server-side templates, like Ruby's ERB or Python’s string formatting, we're going to need client-side JavaScript templates.

There are a number of good candidates, such as [Mustache](http://mustache.github.com) and [jQuery.tmpl](http://api.jquery.com/category/plugins/templates). We're going to demonstrate the latter here, as 

##Templating

Templating options
Storing templates
Spine.app

##Binding


[Templating](<%= docs_path("templating") %>)