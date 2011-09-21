<% title 'Events' %>

Events are a powerful way of de-coupling interaction inside your application. They aren't just restricted to DOM elements, Spine gives you custom events that can be applied to any class or instance. If you're familiar with [jQuery](http://jquery.com) or [Zepto](http://zeptojs.com)'s event API, then you'll feel right at home with Spine's event implementation. Events are a great way of de-coupling and abstracting out components inside your application.

##Implementation

`Spine.Events` is the module Spine uses for adding event support to classes. To use it, just include/extend a class with the module. 

    class Tasks extends Spine.Module
      @extend(Spine.Events)
    
`Spine.Events` gives you three functions, `bind()`, `trigger()`, and `unbind()`. All three have a very similar API to jQuery's event handling one, if you're familiar with that. `bind(name, callback)` takes a event name and callback. `trigger(name, [*data])` takes an event name and optional data to be passed to handlers. `unbind(name, [callback])` takes a event name and optional callback.
    
    Tasks.bind "create", (foo, bar) -> 
    Tasks.trigger "create", "some", "data"

You can bind to multiple events by separating them with spaces. Callbacks are invoked in the context the event is associated with. 

    Tasks.bind("create update destroy", -> @trigger("change"))
    
You can pass optional data arguments to `trigger()` that will be passed onto event callbacks. Unlike jQuery, an event object will not be passed to callbacks.

    Tasks.bind "create", (name) -> alert(name)
    Tasks.trigger "create", "Take out the rubbish"
    
Although you might never use `Spine.Events` in your own classes, you will use it with Spine's models and controllers.

##Global events

You can also bind and trigger global events in your application by calling `Spine.bind()` and `Spine.trigger()`.

    Spine.bind 'sidebar:show', =>
      @sidebar.active()
      
    Spine.trigger 'sidebar:show'
    
However, keep in mind that is often not such a great idea, as it introduces a degree of coupling into your code. Always ask yourself if you can use routes instead, or perhaps local controller events. 

##API documentation

For more information about events, please see the [full API documentation](<%= api_path("events") %>).