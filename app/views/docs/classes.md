<% title 'Classes and Modules' %>

TODO, introduction.


##Implementation

For classes, Spine uses CoffeeScript's [native class implementation](http://arcturo.github.com/library/coffeescript/03_classes.html), for example:

    class User
      # Class method
      @find: (id) ->
        (@records or= {})[id]
      
      # called on instantiation
      constructor: (attributes = {}) ->
        @attributes = attributes

      # Instance method
      destroy: ->
      
To instantiate classes, use the `new` keyword (behind the scenes, classes are constructor functions).
      
    user = new User(name: "Dark Knight")
    user.destroy()
    
    user = User.find(1)
    
To inherit one class for another in CoffeeScript, use `extends`.

    class Users extends Spine.Controller
      constructor: ->
        super

If you're extending another class, and overriding the `constructor` function, make sure you call `super` - especially when it comes to Spine models and controllers.

For more information about classes, see [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/03_classes.html).

##Modules

Spine extends CoffeeScript's classes with support for modules, using `Spine.Module`. This gives you `@extend()` and `@include()` support, for easily adding class and instance properties respectively. To use modules, just inherit a class from `Spine.Module`.
    
    class MyTest extends Spine.Module
      @extend ClassModule
      @include InstanceModule
      
Spine's internal classes inherit from `Spine.Module`, so they all have `@extend()` and `@include()` support:

    class User extends Spine.Model
      @configure "User"
      @extend Spine.Model.Ajax
  
Modules are simply a set of properties, like so:
    
    OrmModule = {
      find: (id) -> /* ... */
    }
    
Modules can also contain callback functions, `extended()` and `included()`:

    OrmModule =
      find: (id) -> /* ... */
      extended: -> 
        console.log("module extended: ", @)

##JavaScript classes

If you're writing your CoffeeScript languages in plain JavaScript, you obviously don't have access to CoffeeScript's class syntax. Spine solves this problem for you, by exposing `Spine.Class`:

    var Users = Spine.Class.sub();
    
Calling `sub()` on a class will subclass it. You can either pass `sub()` a set of instance and class properties, or call `extend()` and `include()` directly on the class. 
    
    Users.extend({
      find: function(id){
        /* ... */         
      }
    });
    
    Users.include({
      destroy: function(){
        /* ... */ 
      }
    });
    
To inherit from the `Users` class in the example above, simple call `sub()` on it:

    var Owner = Users.sub();
    
Rather than `constructor`, class initialization functions are called `init()`

    var User = Spine.Class.sub({
      init: function(){
        // Called on instantiation
        console.log(arguments);
      }
    });
    
    var user = new User({name: "Spock"});

Calling parent (super) functions is slightly more convoluted than in CoffeeScript.

    var User = Spine.Controller.sub({
      init: function(){
        this.constructor.__super__.init.apply(this, arguments)
      }
    });
    
As you can see in the example above, using Spine controllers and models from JavaScript is simply a matter of calling `sub()` on them.

##API

For more information about classes, please see the [full API](<%= api_path("classes") %>).