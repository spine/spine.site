<% title 'Manager' %>

TODO

`Spine.Manager` is essentially a state machine for controllers. Controllers are added to the manager, and the manager controls state for its associated controllers. A controller's state is either *active* or *deactive*. `Spine.Manager` ensures that only one controller is active at any one time; when another controller is 'activated', all other controllers will be deactivated. 

To use the `Manager` class, we first we need to include the *spine.manager.js* script, which you can find in [Spine's repository](https://github.com/maccman/spine/raw/master/lib/spine.manager.js). Let's demonstrate this by creating a couple of controllers, adding them to a `Manager` instance, and change their state. 

    class Users extends Spine.Controller
    class Groups extends Spine.Controller
    
    users  = new Users
    groups = new Groups
    
    new Spine.Manager(users, groups)
    
    users.active()
    assert( users.isActive() )
    assert( !groups.isActive() )
    
    groups.active()
    assert( groups.isActive() )
    assert( !users.isActive() )
    
So, as you can above, Spine gives your controllers an `isActive()` function which returns a boolean indicating whether the controller's state is *active*. In addition, we now have a `active()` function which we can call on controllers to activate them. 

The manager ensures that only one controller in its set is activated at any one time. When the `users` controller is activated (by calling `active()`), the groups controller will be deactivated, and vice versa. 

When a controller is activated, it's `activate()` function will be called. Likewise, when it's deactivated it's `deactivate()` function will be called. These are already implemented, but you can override them to add custom behavior.

By default, the controller's `activate()` function adds an *active* class onto the controller's element (`el`). The deactivate function removes this class.

    // ...
    activate: ->
      @el.addClass("active")
      @

    deactivate: ->
      @el.removeClass("active")
      @
    
Hopefully you're starting to see how we can apply this to showing and hiding views. Take [Holla](http://github.com/maccman/holla) for instance. It has a settings view, and a channel view - both associated with controllers. They need to be displayed independently, and changed using the sidebar menu. 

The simplest way of achieving this is by adding them both to a `Manager`, which will ensure that only one has an *active* class at any one time. Then, with CSS, we can hide views without the *active* class.

    #views > *:not(.active) {
      display: none !important;
    }
    
When the two controllers are activated by the sidebar menu, the *active* class switches and the relevant view is shown.