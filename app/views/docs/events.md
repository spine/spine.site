<% title 'Events' %>

Events are a powerful way of de-coupling interaction inside your application. They aren't just restricted to DOM elements, Spine gives you custom events that can be applied to any class or instance. If you're familiar with [jQuery](http://jquery.com) or [Zepto](http://zeptojs.com)'s event API, then you'll feel right at home with Spine's event implementation. Events are a great way of de-coupling and abstracting out components inside your application.

##Implementation

`Spine.Events` is the module Spine uses for adding event support to classes. To use it, just include/extend a class with the module. 

    //= CoffeeScript
    class Tasks extends Spine.Module
      @extend(Spine.Events)
      
    //= JavaScript
    var Tasks = Spine.Class.sub();
    Tasks.extend(Spine.Events);
    
`Spine.Events` gives you the basic functions, `bind()`, `trigger()`, and `unbind()`. All three have a very similar API to jQuery's event handling one, if you're familiar with that. `bind(name, callback)` takes a event name and callback. `trigger(name, [*data])` takes an event name and optional data to be passed to handlers. `unbind(name, [callback])` takes a event name and optional callback.
    
    //= CoffeeScript
    Tasks.bind "create", (foo, bar) -> alert(foo + bar)
    Tasks.trigger "create", "some", "data"

You can bind to multiple events by separating them with spaces. Callbacks are invoked in the context the event is associated with. 

    //= CoffeeScript
    Tasks.bind("create update destroy", -> @trigger("change"))
    
You can pass optional data arguments to `trigger()` that will be passed onto event callbacks. Unlike jQuery, an event object will not be passed to callbacks.

    //= CoffeeScript
    Tasks.bind "create", (name) -> alert(name)
    Tasks.trigger "create", "Take out the rubbish"
    
Spine has taken inspiration from backbone with `listenTo()`, `listenToOnce()` and `stopListening()`. These allow an object to listen to a events on another object. The advantage of using:

    //= CoffeeScript
    todolist = new TodoList()
    todoList.listenTo currentTask, 'work-done, completed', ->
      doSomething()
    
instead of:

    //= CoffeeScript
    currentTask.bind 'work-done, completed' ->
      doSomething()

is that the former allows the listening object to keep track of the events meaning they can be reliably removed all at once later on, for example if you `release()` or `destroy()` the listening object the events will automattically be unbound leaving things nice and tidy! 

Although you might never use `Spine.Events` in your own classes, you will use it with Spine's models and controllers.


##Global events

You can also bind and trigger global events in your application by calling `Spine.bind()` and `Spine.trigger()`.

    //= CoffeeScript
    Spine.bind 'sidebar:show', =>
      @sidebar.active()
      
    Spine.trigger 'sidebar:show'
    
    //= JavaScript
    Spine.bind('sidebar:show', this.proxy(function(){
      this.sidebar.active();
    });
      
    Spine.trigger('sidebar:show');
    
However, keep in mind that is often not such a great idea, as it introduces a degree of coupling into your code. Always ask yourself if you can use routes instead, or perhaps local controller events. 

##API documentation

For more information about events, please see the [full API documentation](<%= api_path("events") %>).
