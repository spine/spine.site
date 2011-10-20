<% title 'Controllers' %>

Controllers are the last part to the trinity of Spine and are very simple, being more of a set of conventions than actual code. Controllers are the glue inside your application, tying the various components together. Generally, controllers deal with adding and responding to DOM events, rendering templates and keeping views and models in sync.

##Implementation

Controllers, like models, extend `Spine.Module` and so inherit all of its properties. This means you can use `extend()` and `include()` to add properties onto controllers, and can take advantage of all of Spine's context management. To create a controller, inherit a class from `Spine.Controller`.
    
    //= CoffeeScript
    class Tasks extends Spine.Controller
      constructor: ->
        super
        // Called on instantiation
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      init: function(){
        // Called on instantiation
      }
    });

The convention inside Spine is to give the controller a plural camel cased name of the model it is most associated with, in this case the `Task` model. Usually, you'll only be adding instance properties onto controllers, so you can add them inline just like any other class. Instantiating controllers is done by using the `new` keyword.
  
    //= CoffeeScript
    tasks = new Tasks
    
Every controller has an element associated with it, which you can access under the instance property `el`. This element is set automatically when creating a controller instance. The type of element created is specified by the `tag` property, which by default is `"div"`.

    //= CoffeeScript
    class TaskItem extends Spine.Controller
      tag: "li"
      
    # taskItem.el is a <li></li> element
    taskItem = new TaskItem 
    
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      tag: "li"
    });
    
    var taskItem = new TaskItem;

The `el` property can also be set manually by passing it through on instantiation.
    
    //= CoffeeScript
    tasks = new Tasks(el: $("#tasks"));

In fact, anything you pass on instantiation will be set as properties on the newly created instance. For example, you could pass a record that a controller would be associated with.

    //= CoffeeScript
    taskItem = new TaskItem(item: Task.first())

Inside your controller's `constructor()` function, you'll generally add event listeners to models and views, referencing a function inside the controller. 

##Events

Spine gives you a shortcut for adding event listeners onto DOM elements, with the `events` property. 

    //= CoffeeScript
    class Tasks extends Spine.Controller
      events: 
        "click .item": "click"
      
      click: (event) ->
        // Invoked when .item is clicked
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      events: {"click .item": "click"},
      
      click: function(event){
        // Invoked when .item is clicked
      }
    });
    
`events` is an object in the following format `{"eventType selector", "functionName"}`. All the selectors are scoped to the controller's associated element, `el`. If a selector isn't provided, the event will be added directly on `el`, otherwise it'll be delegated to any children matching the selector. 

Spine will take care of callback context for you, making sure it keeps to the current controller. Callbacks will be passed an event object, and you can access the original element the event was targeted on using `event.target`.

    //= CoffeeScript
    class Tasks extends Spine.Controller
      events: 
        "click .item": "click"
  
      click: (event) ->
        item = jQuery(event.target);
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      events: {"click .item": "click"},

      click: function(event){
        var item = jQuery(event.target);
      }
    });

Since Spine uses [delegation](http://api.jquery.com/delegate) for events, it doesn't matter if the contents of `el` change. The appropriate events will still be fired when necessary. 

As well as DOM events, `Spine.Controller` has been extended with `Spine.Events`, meaning that you can bind and trigger custom events. 

    //= CoffeeScript
    class ToggleView extends Spine.Controller
      constructor: ->
        super
        @items = @$(".items")
        @items.click => @trigger("toggle")
        @bind "toggle", @toggle
        
      toggle: ->
        # ...
    
    //= JavaScript
    var ToggleView = Spine.Controller.sub({
      init: function(){
        this.items = this.$(".items");
        this.items.click(this.proxy(function(){
          this.trigger("toggle");
        }));
        this.bind("toggle", this.toggle);
      },
      
      toggle: function(){
        // ...
      }
    });

##Elements

When you first instantiate a controller, it's common to set a bunch of instance variables referencing various elements. For example, setting the `items` variable on the `Tasks` controller:

    //= CoffeeScript
    class Tasks extends Spine.Controller
      constructor: ->
        super
        @items = @$(".items")
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      init: function(){
        this.items = this.$(".items");
      }
    });
    
Since this is such a common scenario, Spine provides a helper, the `elements` property. This is in the format of `{"selector": "variableName"}`. When the controller is instantiated, Spine will go through `elements`, setting the appropriate elements as properties on the instance. Like with `events`, all the selectors are scoped by the controller's current element, `el`.

    //= CoffeeScript
    class Tasks extends Spine.Controller
      elements:
        ".items": "items"
      
      constructor: ->
        super
        @items.each -> #...
        
    //= JavaScript
    var Tasks = Spine.Controller.sub({
      elements: {".items", "items"},
      
      init: function(){
        this.items.each(function(){
          // ...
        });
      }
    });

##API documentation

For more information about controllers, please see the [full API documentation](<%= api_path("controllers") %>).