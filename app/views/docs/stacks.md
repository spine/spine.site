<% title 'Controller Stacks' %>

Stacks are a way of grouping controllers, ensuring that only one controller is activated and displayed at any one time. They're useful in all sorts of common scenarios, such as implementing tabs or displaying independent controllers.

Behind the scenes, Stacks are just Spine Controllers, with an internal [Manager](<%= docs_path("manager") %>) and some API sugar. Stacks are actually defined in the `manager.coffee` lib, so you'll need to require it before using them.

    Stack = require('spine/lib/manager').Stack;

##Usage

A basic stack looks like this, a class extending from `Spine.Stack`:

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

As you can see, we've got a `controllers` property in the format of `{controllerName: controllerClass}`. These controllers will be instantiated automatically when the Stack is instantiated, appended to the stack and an internal [manager](<%= docs_path("manager") %>).

Notice we can access the Stack's controllers when it's instantiated, as in `posts.show`. We can activate individual controllers by calling `active()` on them, deactivating all the other controllers in the stack.

    //= CoffeeScript
    posts = new Posts

    assertEqual( posts.show.isActive(), false )
    posts.show.active()
    assertEqual( posts.show.isActive(), true )

    assert( posts.show.el.hasClass('active') )
    assertEqual( posts.edit.el.hasClass('active'), false )

    //= JavaScript
    var posts = new Posts;

    assertEqual(posts.show.isActive(), false);
    posts.show.active();
    assertEqual(posts.show.isActive(), true);

    assert(posts.show.el.hasClass('active'));
    assertEqual(posts.edit.el.hasClass('active'), false);

###CSS

A Stack doesn't alter the display CSS property of its controllers, but rather simply adds and removes an *active* class. You should add the following snippet to your page's CSS, ensuring that only controller's with an active class are displayed.

    .stack > *:not(.active) {
      display: none
    }

##Routes

Stacks have a shorthand for adding [routes](<%= docs_path("routing") %>) via the `routes` property:

    //= CoffeeScript
    class PostsShow extends Spine.Controller
    class PostsEdit extends Spine.Controller

    class Posts extends Spine.Stack
      controllers:
        show: PostsShow
        edit: PostsEdit

      routes:
        '/posts/:id/edit': 'edit'
        '/posts/:id':      'show'

    //= JavaScript
    var PostsShow = Spine.Controller.sub();
    var PostsEdit = Spine.Controller.sub();

    var Posts = Spine.Stack.sub({
      controllers: {
        show: PostsShow,
        edit: PostsEdit
      },

      routes: {
        '/posts/:id/edit': 'edit',
        '/posts/:id':      'show'
      }
    });

The `routes` property is in the format of `{route: controllerName}`. In this case, we're passing just passing in the controller name as a string. When the route is navigated to, the controller will be activated. We can also use a callback function instead of a controller name.

##Other options

The only other support property in Stacks, is the `default` option. Set this as a controller name, indicating to Spine you want a specific controller to be activated when the Stack is instantiated.

    //= CoffeeScript
    class PostsShow extends Spine.Controller
    class PostsEdit extends Spine.Controller

    class Posts extends Spine.Stack
      controllers:
        show: PostsShow
        edit: PostsEdit

      default: 'show'

    posts = new Posts
    assert( posts.show.isActive() )

    //= JavaScript
    var PostsShow = Spine.Controller.sub();
    var PostsEdit = Spine.Controller.sub();

    var Posts = Spine.Stack.sub({
      controllers: {
        show: PostsShow,
        edit: PostsEdit
      },

      default: 'show'
    });

    var posts = new Posts;
    assert( posts.show.isActive() );

##Advanced options

If you need lower-level control, then you should use Spine's Managers directly. See the [Manager's guide](<%= docs_path("manager") %>) for more information.

