<% title 'Classes' %>

Spine provides classes as part of its JavaScript compatibility layer, as internally, Spine uses CoffeeScript classes. 

##Class methods

### `@sub([includeProperties, extendProperties])`

Used to create new classes, or inherit from existing ones. For example, creating a new class would look like this:

    var User = Spine.Class.sub();
    
Or inheriting from an existing class would look like this:

    var Teacher = User.sub();
    
You can pass in an optional set of include or extend properties that will be added to the class.

    var User = Spine.Class.sub({
      instanceFunction: function(){
        // Blah
      }
    });
    
### `new`

Classes are constructor functions, so they can be instantiated using the `new` keyword:
  
    var User = Spine.Class.sub();
    var user = new User;

### `@extend(Module)`

`@extend()` adds class methods.

    var User = Spine.Class.sub();
    User.extend({
      find: function(){
        /* ... */ 
      }
    });
    
    User.find();

### `@include(Module)`

`@include()` adds instance methods.

    var User = Spine.Class.sub();
    User.include({
      name: "Default Name"
    });
    
    assertEqual( (new User).name, "Default Name" );

### `@proxy(function)`

Wraps a function in a proxy, so it's always invoked in the class' context.

##Instance methods

### `proxy()`

Wraps a function in a proxy, so it's always invoked in the instance's context.