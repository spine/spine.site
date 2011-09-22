<%- title 'Getting Started' %>

Getting started with any new framework or library can be daunting, but I'm going to do my best to ensure your first introduction to Spine is as straightforward as possible.

If you're not into CoffeeScript, and want to use the plain JS version of the library, please see the [Getting Started with JavaScript Guide](<%= docs_path("started_js") %>). Otherwise, let's crack on.

##Spine.app & Hem

Firstly, to make life easier, we're going to install [Spine.app](<%= docs_path("app") %>) and [Hem](<%= docs_path("hem") %>). Spine.app is a Spine application generator. It's not required to use Spine, but very useful all the same. Hem is bit like Bundler for JavaScript apps, see their respective guides for more information.

If you haven't got them installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Both project's sites include excellent installation instructions. Now we can get on with installing the two npm modules we need, `spine.app` and `hem`:

    npm install -g spine.app hem
    
Now we've got an executable called `spine` which we can use to generate new applications. 
    
    spine app my-app
    cd my-app
    
Check out the article on [Spine.app](<%= docs_path("app") %>) for more information concerning its usage. Now let's install the default dependencies listed in our application's `package.json`:

    npm install .

Finally we can use the `hem` executable to run a Hem server, which will temporarily host our Spine application during development.
    
    hem server
    
##Extending our application

Have an explore around the files Spine.app has generated. If you open up [http://localhost:9294](http://localhost:9294) you'll just see a blank page. Let's change our default controller so that it actually does something. 
    
    mate ./app/index.coffee
    
Let's add a `@log()` statement, as demonstrated below:
    
    class App extends Spine.Controller
      constructor: ->
        super
        @log("Initialized")

    module.exports = App
    
Awesome. Now if you reload the application, you should see that log statement in the console.

##Next steps

Now, we've only just scratched the surface here; JavaScript Web applications are a huge area, and constantly evolving. To take your next steps with Spine, read through the [introduction](<%= docs_path("introduction") %>), the [main](<%= docs_path("models") %>) [classes](<%= docs_path("controllers") %>) and the source from some of the [example applications](<%= pages_path("examples") %>).  

You may also be interested in [*JavaScript Web Applications*](http://oreilly.com/catalog/0636920018421) by O'Reilly, which gives you a thorough introduction to all these topics. 

[![JavaScript Web Applications](http://covers.oreilly.com/images/0636920018421/cat.gif)](http://oreilly.com/catalog/0636920018421)