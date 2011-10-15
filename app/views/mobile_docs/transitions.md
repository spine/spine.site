<% title 'Transitions' %>

Transitions are all activated by [Spine Managers](<%= docs_path("manager") %>), so it's worth familiarizing yourself with Managers if you haven't already done so. In a nutshell, transitions slide-on, or slide-off Panels whenever the panel is activated or deactivated respectively. 

Behind the scenes, transitions use jQuery and [GFX](http://maccman.github.com/gfx) which programmatically manipulate CSS transforms, performing the transition. The neat thing about this approach is that the transitions are all hardware accelerated, greatly improving performance on mobile devices. Spine hides all this behind a very simple API.

##Activating Panels

Activating Panels, as we've seen in the previous [controllers section](<%= mobile_path("controllers") %>), is done with the `active()` function.

    class ContactsList extends Panel
      # ...
      
    list = new ContactsList
    list.active()
    
By default, this doesn't use any transitions, simply showing the controller. In order use a transition, pass the `trans` option to `active()`:
    
    # Transition in from left
    list.active(trans: 'left')
    
    # Or, transition in from right
    list.active(trans: 'right')
    
Any deactivating panels will automatically use the reverse of this transition, i.e. sliding out from the right and left respectively. Currently, only two transition types are supported, `left` and `right`, but more will follow in the future.

##Routes

If you're not familiar with Routes, it's worth getting a short primer by reading the [routing guide](<%= docs_path("routing") %>) before this section.

Panels are usually activated by routes, but how are transitions specified in this scenario? Well, Spine lets you pass a custom objects when invoking routes, as the last argument to `@navigate()`. For example:

    @navigate('/contacts', trans: 'left')
    
The object `{trans:'left'}` is then passed onto the route callback, like so:

     @routes
        '/contacts': (params) -> 
          assertEqual( params.trans, 'left' )
          
You should then pass the route callback params to `active()`, like so:

    @list = new ContactsList
    @routes
       '/contacts': (params) -> 
          @list.active(params)
          
Voilà, that's all there is to it! Let's take a look at a full example then, to get some context:   

    class ContactsCreate extends Panel
      className: 'contacts create'
      # ...

    class ContactsList extends Panel
      className: 'contacts list'

      constructor: ->
        super
        @addButton('Add Contact', @add)

      add: ->
        @navigate('/contacts/create', trans: 'right')
    
    class Contacts extends Spine.Controller
      constructor: -> 
        super

        @list   = new ContactsList
        @create = new ContactsCreate

        @routes
          '/contacts':        (params) -> @list.active(params)
          '/contacts/create': (params) -> @create.active(params)

You can see the transition to the `ContactsCreate` Panel specified in the `add()` function. Also notice the way the routing is configured to pass on the `params` object, to the `active()` function, so the controller knows what sort of transition to use. 

##Video demonstration

Let's take a look at the transitions in practice:

<iframe src="http://player.vimeo.com/video/29557829?title=0&amp;byline=0&amp;portrait=0" width="250" height="360" frameborder="0" webkitAllowFullScreen allowFullScreen></iframe>

##Next step

Now we've covered [controllers](<%= mobile_path("controllers") %>) and transitions, the next step is to look at [events](<%= mobile_path("events") %>), and how they differ in mobile applications. 