<% title 'CommonJS modules' %>

By default, JavaScript runs programs in a global scope and doesn't have any native namespacing language features. This means that, unless you're careful, your programs can descend into a mess of code spaghetti, full of conflicting variables and namespace pollution.

CommonJS modules are one of the best solutions to JavaScript dependency management. 

CommonJS modules solve JavaScript scope issues by making sure each module is executed in its own namespace. Modules have to explicitly export variables they want to expose to other modules, and explicitly import other modules; in other words, there's no global namespace. 

In my opinion, CommonJS modules are the best system for JavaScript dependency management. Here's a quote from my book [JavaScript Web Applications](http://oreilly.com/catalog/9781449307530/) explaining the benefits:

> Not only have we split our code up into separate module components, the secret to good application design, but we've also got dependency management, scope isolation and namespacing.

If you've ever use Node or Python you've used CommonJS modules, whether you realize it or not. In a nutshell, CommonJS modules give you require and exports, letting you require other modules and expose variables to other modules. For example:
  
    //= CoffeeScript
    # example.js
    exports.hello = -> 'hello world'

    # application.js
    example = require("example");
    alert example.hello()
    
    //= JavaScript
    // example.js
    exports.hello = function(){ return 'hello world'; };

    // application.js
    var example = require("example");
    alert(example.hello());
    
Although their syntax is simple, I can't emphasize enough how useful CommonJS modules are. They go a long way to solve conflicts and variable pollution problems in JavaScript - two absolutely critical pieces to JavaScript dependency management.

##Usage

Properties are exported by either setting them on the `exports` object, or by setting the `module.exports` variable.
    
      //= CoffeeScript
      class MyClass
      module.exports = MyClass

      //= JavaScript
      var MyClass = Spine.Class.sub();
      module.exports = MyClass;

External modules are then imported in using the `require()` function, setting the returned value to a local variable:

      //= CoffeeScript
      MyClass = require('models/my_class')
      
##Tools

If you're building Spine application's with [Hem](<%= docs_path("hem") %>), then all this has been taken care of for you. Your CoffeeScript and JavaScript scripts will automatically be wrapped up in the CommonJS format.

If you're not using Hem, but you are using [Node.js](http://nodejs.org), you should checkout [Stitch](https://github.com/sstephenson/stitch), which will make sure all your libraries are *stitched* together into CommonJS modules, ready to run straight inside the browser.

I've also ported Stitch to Ruby, with the [stitch-rb](https://github.com/maccman/stitch-rb) project. This lets you use CommonJS modules right inside your Rails applications. Usage is simple, checkout the [README](https://github.com/maccman/stitch-rb) for more information.

##Alternatives

There are lots of alternative solutions to the problem of JavaScript dependency management, and you should definitely check them out if CommonJS modules aren't the right fit for you. [RequireJS](http://requirejs.org/) is a JavaScript file and modules loader, and has the advantage that it is browser-based, and doesn't require any server side support.

[Sprockets](https://github.com/sstephenson/sprockets) is another good alternative, and if you're using Rails, it has the added advantage that it's already baked into the asset-pipeline. Whilst it doesn't use CommonJS modules, it does ensure that individual modules are executed inside a closure, localizing the context. A good half-way house. 
