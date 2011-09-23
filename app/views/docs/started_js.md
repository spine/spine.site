<%- title 'Getting Started with JavaScript' %>

Although Spine is written in CoffeeScript, it's fully compatible with applications written in pure JavaScript. You can use whichever technology you prefer. The API largely remains the same, except for a few key differences which are documented below. 

##Prerequisites

Spine requires either [jQuery](http://jquery.com) or [Zepto](http://zeptojs.com). Most of the library will function without these, such as the [Class abstraction](<%= docs_path("classes") %>), but Spine's [Controller](<%= docs_path("controllers") %>) class requires them. Just be sure to include either of those two libraries before Spine.

##Downloading

Grab the [latest version of Spine](<%= pages_path("download") %>), and unpack it. The compiled CoffeeScript scripts you need are all in the `lib` folder. Include them in your application as with any other JavaScript library, making sure you include `spine.js` before any of the other libraries:

    <script src="lib/jquery.js"></script>
    <script src="lib/spine.js"></script>
    
    <!-- Optional Spine extensions -->
    <script src="lib/local.js"></script>
    <script src="lib/routes.js"></script>

##Next steps

To take your next steps with Spine, read through the [introduction](<%= docs_path("introduction") %>), the [main](<%= docs_path("models") %>) [classes](<%= docs_path("controllers") %>) and the source from some of the [example applications](<%= pages_path("examples") %>).

##Key differences

The key difference between Spine programs written in JavaScript, and ones in CoffeeScript, is the lack of CoffeeScript classes. Classes and inheritance are emulated by CoffeeScript behind the scenes when you use the `class` keyword, since they're not natively available in JavaScript. However, Spine provides an alternative API to use Classes in JavaScript, so the same functionality is still available to you.

    var SomeClass = Spine.Class.sub();
    
To create a new Class, call `sub()` on the `Spine.Class` object. This subclasses `Spine.Class`, returning a new class ready for you to customize. Adding instance and class methods is easy as calling `include()` and `extend()` respectively.

    var SomeClass = Spine.Class.sub();
    
    SomeClass.extend({
      property: false,
      
      find: function(){
        
      }
    });
    
    SomeClass.include({
      attributes: {}
    });
    
Or, as a shortcut, you pass properties when calling `sub([instanceProperties, classProperties])`.

Inheriting from a class is as simple as calling `sub()` on it:

    var SomeClass = Spine.Class.sub({
      attributes: {},
      save: function(){ /* ... */ }
    });
    
    var DifferentClass = SomeClass.sub({
      destroy: function(){ /* ... *},

      // Override property: 
      save: function(){ /* ... */ }
    });
    
Behind the scenes, classes are constructor functions, and can instantiated using the `new` keyword.

    var User = Spine.Class.sub({
      init: function(name){
        this.name = name;
      }
    });
    
    var user = new User('Flynn');
    alert(user.name + ' lives!');
    
Spine's [Models](<%= docs_path("models") %>) and [Controllers](<%= docs_path("controllers") %>) are just Classes, and can be sub-classed just the same:

    var User = Spine.Model.sub();
    User.configure('User', 'name', 'email');
    
    var Users = Spine.Controller.sub({
      init: function(){
        User.bind('change refresh', this.proxy(this.render))
      },
      
      render: function(){ /* ... */ }
    });

##Module pattern

Since JavaScript has a global namespace, you should get used to encapsulating your code in modules, ensuring against namespace pollution and conflicts. 

The easiest way to do this it to surround your JavaScript in an anonymous function, like so:

    (function(Spine, $, exports){
      // Your code goes here...
    })(Spine, Spine.$, window);
    
The variable `Spine.$` refers to jQuery, or Zepto, whichever library you're using. If you need to create a global variable, you can do so by setting it as a property on the `exports` object (which refers to the `window`). This makes it obvious to the casual observer what global variables a script is creating.
    
    (function(Spine, $, exports){
      var Contacts = Spine.Controller.sub({
        init: function(){
          // ...
        }
      });
      
      exports.Contacts = Contacts;
    })(Spine, Spine.$, window);
    
    (function(Spine, $, exports){
     var contacts = new Contacts({el: $('body')});
    })(Spine, Spine.$, window);
    
Each of your classes should be in separate files, and it's recommended to concatenate them together using a library like [Hem](<%= docs_path("hem") %>), [Stitch](https://github.com/sstephenson/stitch) or [Sprockets](https://github.com/sstephenson/sprockets). 

<script>
  jQuery(function($){
    // Select JavaScript docs by default
    $('select#preview').val('JavaScript').change()
  });
</script>
