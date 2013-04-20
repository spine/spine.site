<% title 'Manager' %>

`Spine.Manager` is essentially a state machine for controllers. Controllers are added to the manager, and the manager controls state for its associated controllers. A controller's state is either *active* or *deactive*. `Spine.Manager` ensures that only one controller is active at any one time; when another controller is 'activated', all other controllers in the manager will be deactivated. 

Managers are great for having a set of views, and ensuring that only one of those views is displayed at any one time. 

##Stacks

You may find it easier to use [Spine's Stacks](<%= docs_path("stacks") %>), as they abstract Managers providing a more high level API.

    //= CoffeeScript
    class PostsShow extends Spine.Controller
    class PostsEdit extends Spine.Controller

    class Posts extends Spine.Stack
      controllers:
        show: PostsShow
        edit: PostsEdit
    
    posts = new Posts
    posts.show # <PostsShow>
    
    posts.show.active()
    posts.show.isActive() # true
    posts.edit.isActive() # false
    
    //= JavaScript
    var PostsShow = Spine.Controller.sub();
    var PostsEdit = Spine.Controller.sub();

    var Posts = Spine.Stack.sub({
      controllers: {
        show: PostsShow,
        edit: PostsEdit
      }
    });
        
    var posts = new Posts
    posts.show // <PostsShow>
    
    posts.show.active();
    posts.show.isActive(); // true
    posts.edit.isActive(); // false
    
See the [Stacks guide](<%= docs_path("stacks") %>) for more information.

##Usage

To use the `Manager` class, we first need to include the *manager.js* script, which you can find in [Spine's repository](https://github.com/spine/spine/raw/master/lib/manager.js). Let's demonstrate this by creating a couple of controllers, adding them to a `Manager` instance, and change their state. 
    
    //= CoffeeScript
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
    
    //= JavaScript
    var Users = Spine.Controller.sub();
    var Groups = Spine.Controller.sub();
    
    var users = new Users;
    var groups = new Groups;
    
    new Spine.Manager(users, groups);
    
    users.active();
    assert( users.isActive() );
    assert( !groups.isActive() );
    
    groups.active();
    assert( groups.isActive() );
    assert( !users.isActive() );
    
So, as you can see above, Spine gives your controllers an `isActive()` function which returns a boolean indicating whether the controller's state is *active*. In addition, we now have an `active()` function which we can call on controllers to activate them. 

The manager ensures that only one controller in its set is activated at any one time. When the `users` controller is activated (by calling `active()`), the groups controller will be deactivated, and vice versa. 

When a controller is activated, its `activate()` function will be called. Likewise, when it's deactivated, its `deactivate()` function will be called. These are already implemented, but you can override them to add custom behavior.

By default, the controller's `activate()` function adds an *active* class onto the controller's element (`el`). The `deactivate()` function removes this class.

    //= CoffeeScript
    # ...
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

##Spine Mobile

Managers are behind all the [view transitions](<%= mobile_path("transitions") %>) in Spine Mobile. Checkout the [Spine Mobile source](https://github.com/maccman/spine.mobile), especially the [Stage controller](https://github.com/maccman/spine.mobile/blob/master/src/stage.coffee), for a good example of overriding the `activate()` and `deactivate()` functions in order to display custom transitions. 
