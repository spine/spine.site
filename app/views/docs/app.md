<% title 'Using Spine.app' %>

Spine.app is a Spine application generator. It'll create the basic application structure, as well as controllers and models. This can then be served up, or compiled, using [Hem](<%= docs_path("hem") %>).

Spine.app is an excellent way of getting started with Spine applications, and a highly recommended workflow.

##Installation

First, if you haven't got them installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Then, to install Spine.app:

    npm install -g spine.app
    
Spine.app will now be available globally under the `spine` executable.
    
##Generating your application

To generate your application, use the `app` generator like so:
    
    spine app my_app
    
Now we've produced a directory structure looking like:

    my_app/.gitignore
    my_app/.npmignore
    my_app/Procfile
    my_app/app
    my_app/app/controllers
    my_app/app/index.coffee
    my_app/app/lib
    my_app/app/lib/setup.coffee
    my_app/app/models
    my_app/app/views
    my_app/app/views/sample.jade
    my_app/css
    my_app/css/index.styl
    my_app/css/mixin.styl
    my_app/lib
    my_app/lib/runtime.js
    my_app/package.json
    my_app/public
    my_app/public/favicon.ico
    my_app/public/index.html
    my_app/slug.json
    my_app/test
    my_app/test/lib
    my_app/test/lib/run-jasmine.phantom.js
    my_app/test/public
    my_app/test/public/index.html
    my_app/test/public/lib
    my_app/test/public/lib/jasmine-html.js
    my_app/test/public/lib/jasmine.css
    my_app/test/public/lib/jasmine.js
    my_app/test/specs
    
As you can see spine.app has set up simple but fairly complete structure for your application.

The `Procfile` is for [Heroku](http://heroku.com), which we'll cover later. `slug.json` is for Hem, see the [article on that](<%= docs_path("hem") %>) for more information. The rest is your classical MVC structure, which should look very familiar to you if you've used Rails.

First let's navigate to our application, and install it's npm dependencies:
    
    $ cd my_app
    $ npm install .
    
These dependencies will be stored locally in the `my_app/npm_modules` folder. Spine.app is currently set up to help you build a app that is fairly compatible with less capable browsers by relying on some shims and including jquery 1.9.1. If you are targeting more cutting edge browsers you'll want to refine your dependencies in `slug.json` and `app/lib/setup.coffee`

Now you can generate some controllers, models and get to building your app!

##Generating controllers

Simple enough, just use the `controller` generator, specifying the name of the controller. 
    
    spine controller users
    
In the example above, Spine will generate a controller under `./app/controllers/users.coffee`

    Spine = require('spine')

    class Users extends Spine.Controller
      constructor: ->
        super

    module.exports = Users
    
And a jasmine spec under `./test/specs/controllers/users.coffee`
    
By convention, your controllers should be plural and your models singular. Spine.app does nothing to enforce this, it's up to you.
    
##Generating models

Use the `models` generator, specifying the name of the model.
    
    spine model user
    
In the example above, Spine will generate a model under `./app/models/user.coffee`

    Spine = require('spine')

    class User extends Spine.Model
      @configure "User"
      
And a jasmine spec under `./test/specs/models/user.coffee`
    
##Serving your application

As soon as it's generated and its dependencies are installed your application will be ready to be served using [Hem](<%= docs_path("hem") %>). Firstly, you'll need to install Hem, and your application's dependencies:

    npm install .
    npm install -g hem
    
And now we can use Hem to serve up the application:

    hem server
    
For more information regarding Hem, please see the [Hem Guide](<%= docs_path("hem") %>).
    
##Building your application

You can also use Hem to test and build your application. This will serialize all your JavaScript/CoffeeScript to one file (`./public/application.js`), all your CSS/Stylus to (`./public/application.css`). You'll need to do this before pushing your site to a remote server, so it can be served statically.
    
    hem test
    
By default hem test expects the headless browser Phantom to be installed for running tests against but you can configure this to use others as well. 

Testing in this way will build your CSS and JS and run the tests against those. 

Assuming tests pass you would be able to commit it to your source controll and deploy

If you're feeling lucky or if you ran your tests in the browser while `hem server` was going you can go straight to

    hem build
    
##Heroku

Now that your application has been serialized to disk using `hem build`, you can deploy it. [Heroku](http://heroku.com) is a great option for serving Node.js and Rails applications.  

If you take a peek inside `package.json`, you'll see that there's a dependency on `ace`. Ace is a super simple static file server, and all we need to serve up our application in production. Our application's `Procfile` looks like this:

    web: ace ./public
    
This instructs Heroku to use Ace to serve up the application's `public` directory.

Now, all we need to deploy our app is run a few Heroku commands. You'll need to install the Heroku [gem](https://rubygems.org/gems/heroku) if you haven't already. 

    heroku create my-spine-app --stack cedar
    git add .
    git commit -m "first deploy"
    git push heroku master
    heroku open

Voila! Your Spine application has been deployed.
