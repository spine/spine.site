<% title 'Views & Templating using Jade' %>
  
As templating libraries go, you can't go far wrong with [Jade](http://jade-lang.com/). It's easily installable via npm `npm install jade`, and is a common templating solution used with the node.js MVC framework Express. The format is very similar to Haml and is [well documented](https://github.com/visionmedia/jade#readme). 

As well being able to use coffeescript and stylus within jade templates jade has a very consice way of expressing html content. There are parts of jade that are most usefull on the server side, but plenty of stuff that is still useful on the client side like mixins and includes. If your spine app is complimenting a node.js app that uses jade it can be pretty awesome to only have to handle one type of view template!

##Usage

The simplest way of using jade is via hem which will automatically compile your jade views for you. simply include your `.jade` files in the view directory of your spine app and require them from your controllers. 

    class Contacts extends Spine.Controller
      constructor: ->
        super
        @render()
      
      render: ->
        @html require('views/contacts')
  
##Jade Syntax

The syntax is fairly straightforward, if you are familiar with Haml or Zen-coding you'll pick it right up:

    -var klass = (type == null ? null : 'changeBox')
    div(class=klass)
    if type == null
      input(type="text", name="searchField", placeholder="find by name..", title="find by name")
      a.add.createOriginTrigger(href="#", title="Create New Contact") +
    else
      div.changeControls
        a(href="#", class="change contactChange") switch
        a(href="#", class="edit contactEdit") edit
    p
      span.subLabel Name
      span.val #{name}
    p
      span.subLabel Phone
      span.val #{phone1}
    input.contactId(type="hidden", value=id)

##Data association

Data association is up to you to handle, if needed, in you controller logic. There are numerous ways to do this, for example:

    //= CoffeeScript
    elements:
      'table' : 'contactsTable'
    
    events:
      '.itemRef': 'edit'
      '.delete' : 'deleteItem'
    
    list: ->
      items = Contact.all()
      listContent = ''
      for item in items
        listContent += require('views/contact/item')(item)
      @contactsTable.html listContent
      
    edit: (e) ->
      e.preventDefault()
      itemId = $(e.target).parent('tr').data('itemid')
      # or
      itemId = $(e.target).attr('href')
      ...
    
    delete: (e) ->
      e.preventDefault
      itemId = $(e.target).parent('tr').data('itemid')
      ...

the the `views/contact/item` might look like this

    tr.item(data-itemid=id)
      td
        a.edit(href=id)= name
      td= locals.phone
      td= locals.email
      td
        a.delete(alt='delete'): span.icon-erase


##Binding

Data binding is a very powerful technique for ensuring model data stays in sync with the view. The premise is that controllers bind to model events, re-rendering the view when those events are triggered. Let's take a simple example, a list of contacts. The controller will bind to the `Contact` model's *refresh* and *change* events, which are triggered whenever the model's data changes. When the event is triggered, the controller re-renders the view.

    //= CoffeeScript
    class ContactsList extends Spine.Controller
      constructor: ->
        Contact.bind('refresh change', @render)
        
      render: =>
        items = Contact.all()
        @html = ''
        for item in items
          @append require('views/contacts')(items)
    

There are several common binding patterns, see the [controller patterns guide](<%= docs_path("controller_patterns") %>) for more information.

##Other Considerations

To use precompiled jade templates in the browser you must include jade's [runtime.js](https://raw.github.com/visionmedia/jade/master/runtime.js). In Hem you can add this a as a lib in your spine projects slug.json.
