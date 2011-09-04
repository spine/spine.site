<% title "Classes" %>

Spine's class implementation is one of its features that makes it stand out from the crowd. Rather than copying properties to emulate inheritance, as most libraries, Spine uses JavaScript's native prototypal inheritance. This is how inheritance should be done, and means it's dynamic, properties are resolved at runtime.

Classes are created like so:

    var Task = Spine.Class.create();

`create()` takes optional arguments of instance properties, and class properties.

    Spine.Class.create([instanceProperties, classProperties]);

    var User = Spine.Class.create({
      name: "Carolin"
    });
    
Alternatively you can add instance properties using `include()`, and class properties with `extend()`.

    var User = Spine.Class.create();
    
    User.extend({
      find: function(){ /* ... */ }
    });
    
    User.include({
      name: "Tonje"
    });

Since Spine doesn't use constructor functions, due to limitations with prototypal inheritance, classes are instantiated with `init()`.

    var User = Spine.Class.create({
      name: "Tonje"
    });
    
    var user = User.init();
    
    assertEqual( user.name, "Tonje" );
    user.name = "Trish";
    assertEqual( user.name, "Trish" );

Any arguments passed to `init()` will be forwarded to `init()`, the classes' instantiation callback.

    var User = Spine.Class.create({
      init: function(name){
        this.name = name;
      }
    });

    User.init("Martina");
    assertEqual( user.name, "Martina" );

Sub-classes are created the same way base classes are, with `create()`.

    var Friend = User.create();
    
All of the subclass's parent properties are inherited.

    var friend = Friend.init("Tim");
    
    assertEqual( friend.name, "Tim" );
    
Because we're using real prototypal inheritance, properties are resolved dynamically at runtime. This means that you can change the properties of a parent class, and all its sub-classes with reflect those changes immediately. 

    var User   = Spine.Class.create();
    var Friend = User.create();
    
    User.include({defaultName: "(empty)"});

    assertEqual( Friend.init().defaultName, "(empty)" );

##Context

Context changes constantly in JavaScript, and it's very important your code is executing in the correct one. The most common cause of this is with event listeners, where callbacks will be invoked in the context of `window` or the element, rather than their original context. To resolve this, Spine's classes provides a few helper functions for maintaing context.

You can pass a function to `proxy()` to guarantee that it will be invoked in the current context.

    var Tasks = Spine.Class.create({
      init: function(){
        $("#destroy").click(this.proxy(this.destroy));
      },
      
      destroy: function(){ /* ... */ }
    });

Or pass multiple function names to `proxyAll()` in order to re-write them permanently, so they're always called with the classes' local content. 

    var Tasks = Spine.Class.create({
      init: function(){
        this.proxyAll("destroy")
        $("#destroy").click(this.destroy);
      },
      
      destroy: function(){ /* ... */ }
    });