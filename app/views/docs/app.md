<% title 'Using Spine.app' %>

Spine.app is a Spine application generator. It'll create the basic application structure, as well as controllers and models. This can then be served up, or compiled, using [Hem](<%= docs_url("hem") %>).

Spine.app is an excellent way of getting started with Spine applications, and a highly recommended workflow.

##Installation

First, if you haven't got it installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Then, to install Spine.app:

    npm install -g spine.app
    
Spine.app will now be available globally under the `spine` executable.
    
##Generating your application

To generate your application, use the `app` generator like so:
    
    spine app my_app
    
Spine.app will generate the initial application files, which look like this:
    
    ./app
    ./app/controllers
    ./app/controllers/.gitkeep
    ./app/index.coffee
    ./app/models
    ./app/models/.gitkeep
    ./app/views
    ./app/views/.gitkeep
    ./css
    ./css/index.styl
    ./package.json
    ./Procfile
    ./public
    ./public/favicon.ico
    ./public/index.html
    ./slug.json
    
The `Procfile` is for [Heroku](http://heroku.com), which we'll cover later. `slug.json` is for Hem, see the [article on that](<%= docs_url("hem") %>) for more information. The rest is your classical MVC structure, which should look very familiar to you if you've used Rails.

Now `cd` into your application directory, and you can generate some controllers, models and serve up the application.    
    
##Generating controllers

Simple enough, just use the `controller` generator, specifying the name of the controller. 
    
    spine controller users
    
In the example above, Spine will generate a controller under `./app/controllers/users.coffee`

    Spine = require('spine')

    class Users extends Spine.Controller
      constructor: ->
        super

    module.exports = Users
    
By convention, your controllers should be plural and your models singular. Spine.app does nothing to enforce this, it's up to you.
    
##Generating models

Use the `models` generator, specifying the name of the model.
    
    spine model user
    
In the example above, Spine will generate a model under `./app/models/user.coffee`

    Spine = require('spine')

    class User extends Spine.Model
      @configure "User"
    
##Serving your application

As soon as it's generated, your application is all ready to be served using [Hem](<%= docs_path("hem") %>).

    hem server
    
For more information regarding Hem, please see the [Hem Guide](<%= docs_path("hem") %>).
    
##Building your application

You can also use Hem to build your application. This will serialize all your JavaScript/CoffeeScript to one file (`./public/application.js`), and all your CSS/Stylus (`./public/application.css`). You'll need to do this before pushing your site to a remote server, so it can be served statically.

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