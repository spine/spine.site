<% title 'Controller Patterns' %>

We've covered most of Spine's Controller API in the [controller guide](<%= docs_path("controllers") %>), so let's have a look at some typical use cases. 

##The Render Pattern

The *render pattern* is a really useful way of binding models and views together. When the controller is instantiated, it adds an event listener to the relevant model, invoking a callback when the model is refreshed or changed. The callback will invoke the `render()` function, updating the controller's element (`el`) by replacing its contents with a rendered template. 

    //= CoffeeScript
    class Contacts extends Spine.Controller
      constructor: ->
        super
        Contact.bind("refresh change", @render)

      template: (items) ->
        require('views/contacts')(items)

      render: =>
        @html(@template(Contact.all()))
    
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      init: function(){
        Contact.bind("refresh change", this.proxy(this.render));
      },
      
      template: function(items){
        return $('#contactTemplate').tmpl(items);
      },
      
      render: function(){
        this.html(this.template(Contact.all()));
      }
    })
    
This is a simple but blunt method for data binding, updating every element whenever a single record is changed. This is fine for uncomplicated and small lists, but you may find you need more control over individual elements, such as adding event handlers to items. This is where the *element pattern* comes in.

##The Element pattern

The element pattern essentially gives you the same functionality as the render pattern, but a lot more control. It consists of two controllers, one that controls a collection of items, and the other deals with each individual item. Let's dive right into the code to give you a good indication of how it works.

    //= CoffeeScript
    class ContactItem extends Spine.Controller
      # Delegate the click event to a local handler
      events:
        "click": "click"
      
      # Bind events to the record
      constructor: ->
        super
        throw "@item required" unless @item
        @item.bind("update", @render)
        @item.bind("destroy", @remove)

      # Render an element
      render: (item) =>
        @item = item if item

        @html(@template(@item))
        @

      # Use a template, in this case via Eco
      template: (items) ->
        require('views/contacts')(items)

      # Called after an element is destroyed
      remove: ->
        @el.remove()
      
      # We have fine control over events, and 
      # easy access to the record too
      click: ->

    class Contacts extends Spine.Controller
      constructor: ->
        Contact.bind("refresh", @addAll)
        Contact.bind("create",  @addOne)

      addOne: (item) =>
        contact = new ContactItem(item: item)
        @append(contact.render())

      addAll: =>
        Contact.each(@addOne)
    
    //= JavaScript
    var ContactItem = Spine.Controller.sub({
      
      // Delegate the click event to a local handler
      events: {
        "click": "click"
      },
      
      // Bind events to the record
      init: function()
        if ( !this.item ) throw "@item required";
        this.item.bind("update", this.proxy(this.render));
        this.item.bind("destroy", this.proxy(remove));
      },
      
      render: function(item){
        if (item) this.item = item;
        
        this.html(this.template(this.item));
        return this;
      },
      
      // Use a template, in this case via jQuery.tmpl.js
      template: function(items){
        return $('#contactTemplate').tmpl(items);
      },
      
      // Called after an element is destroyed
      remove: function(){
        this.el.remove();
      },
      
      click: function(){
        // We have fine control over events, and 
        // easy access to the record too
      }
    });

    var Contacts = Spine.Controller.sub({
      init: function(){
        Contact.bind("refresh", this.proxy(this.addAll));
        Contact.bind("create",  this.proxy(this.addOne));
      },
      
      addOne: function(item){
        var contact = new ContactItem({item: item});
        this.append(contact.render());
      },
      
      addAll: function(){
        Contact.each(this.proxy(this.addOne));
      }
    });        
    
In the example above, `Contacts` has responsibility for adding records when they're initially created, and `ContactItem` has responsibility for the record's update and destroy events, re-rendering the record when necessary. Albeit more complicated, this gives us some advantages over the previous render pattern. 

For one thing, it's more performant; the list doesn't need to be re-drawn whenever a single element changes. Furthermore, we now have a lot more control over individual items. We can place event handlers, as demonstrated with the `click` callback, and manage rendering on an item by item basis.

##Next steps

A great example of the *element pattern* is Spine's TodoList example application, which is covered in depth in the [TodoList guide](<%= docs_path("example") %>).
