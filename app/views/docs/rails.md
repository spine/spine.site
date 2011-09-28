<% title 'Rails integration' %>

Spine's architecture complements Rails apps, and the two sit really well together. Rails makes a great backend API for data storage and authentication, whilst Spine provides your application with an awesome front-end and user experience. 

##Architecture

You need to decide, based on the size and complexity of your Spine app, whether you're going to base it inside your Rails project, or use something like [Hem](<%= docs_path("hem") %>) to serve it. If the app's anything more than a simple widget, I recommend the latter approach. Regardless, the integration between Spine and Rails should be limited to a JSON REST API. 

Ultimately, if you're building a full featured Spine app, Rails should become no more than an API layer, abstracting the database, ensuring validation and providing authentication. Ideally your Spine app should exist totally independently from Rails, communicating through the API. The advantage to this approach is that you get a de-coupled application, and also an API for free, which you can then open up to other developers.

I've provided an example Rails app demonstrating Spine integration here: [https://github.com/maccman/spine.rails3](https://github.com/maccman/spine.rails3)

[![Spine & Rails](https://lh5.googleusercontent.com/-I3Cig6gg0_w/ToHHN7OQg-I/AAAAAAAABaQ/Di0r0pLvitw/s400/Screen%252520Shot%2525202011-09-27%252520at%25252013.52.19.png)](https://github.com/maccman/spine.rails3)

There's also a [live demo](http://spine-rails3.herokuapp.com) of the application, go and give it [a whirl](http://spine-rails3.herokuapp.com). Notice that the UI is completely instant. There's absolutely no places where it blocks, even after creating a record. Ajax requests are sent in the background to keep the server in sync.  

If you do intend to serve up your Spine app through Rails, there are two approaches: Sprockets or Stitch. 

##Sprockets

Rails uses [Sprockets](https://github.com/sstephenson/sprockets) internally to manage JavaScript and CSS assets. Spine includes support for Sprockets integration through the `spine-rails` gem. First off, add the required dependencies to your `Gemfile`:

    gem 'jquery-rails'
    
    # Optional support for jQuery templates
    gem 'sprockets-jquery-tmpl' 
    
    # Embed Spine automatically
    gem 'spine-rails'
    
Now you'll need to create a directory structure for your Spine app under `app/assets/javascripts`. I suggest something like this:
    
    app
    app/lib
    app/models
    app/controllers
    app/views

Then, let's provide an `app/index.coffee` file, which will load the Spine application:

    #= require json2
    #= require jquery
    #= require jquery-tmpl
    #= require spine
    #= require spine/manager
    #= require spine/ajax
    #= require spine/tmpl
    #= require spine/route
    #
    #= require_tree ./lib
    #= require_tree ./models
    #= require_tree ./controllers
    #= require_tree ./views
    
As you can see, it's requiring the various Sprocket modules, such as `spine` and `jquery`, then loading our application. Let's check its working by navigating to [http://localhost:3000/assets/app.js](http://localhost:3000/assets/app.js). You should see a concatenated JavaScript file full of our libraries. Any controllers or models we create will be automatically included in it. 

To get the `app.js` automatically pre-compiled in production, you'll need to add it to the `precompile` configuration in `production.rb`:

    config.assets.precompile += %w( app.js )

###Namespacing

CoffeeScript automatically wraps scripts in anonymous modules, so it doesn't pollute the global scope. However, sometimes you'll need to create global variables. You can create these by explicitly setting them on the `window` object.

    class Contacts extends Spine.Controller
    window.Contacts = Contacts
    
##Stitch

An alternative to using Sprockets for Spine integration is [Stitch](https://github.com/maccman/stitch-rb). Stitch has the advantage that it outputs [CommonJS modules](<%= docs_path("commonjs") %>), rather than use just simple concatenation. Using Stitch is beyond the scope of this guide, please see its [README](https://github.com/maccman/stitch-rb) for more information. 

##JSON Prefixing

When sending JSON Ajax requests, Spine doesn't prefix any of it's data with the model name. For example, once a record has been created, Spine will will send a POST request with a payload looking like this:

    {"name": "Sam Seaborn"}

Instead of something most Rails programmers are familiar with, prefixed data:

    {"user": {name: "Sam Seaborn"}}

The reason for this design decision is that the prefix is often redundant data; the application already knows the format and indented destination of the data by the context of the HTTP request. 

Fortunately Rails 3.1 has added default support for un-prefixed parameters, via a feature called *wrap parameters*. You should find a file under `config/initializers/wrap_parameters.rb` that looks like this:

    ActionController::Base.wrap_parameters format: [:json]

    # Disable root element in JSON by default.
    if defined?(ActiveRecord)
      ActiveRecord::Base.include_root_in_json = false
    end

Spine also requires responses from the server to be un-prefixed. As in the example above, `ActiveRecord::Base.include_root_in_json` should be `false`.

Both these settings are the **default** in Rails 3.1, and you shouldn't need to alter them.

##Ajax & REST

Spine's [Ajax module](<%= docs_url("ajax") %>) is fully REST compatible, and will work with Rails out of the box. One thing to look out for, is that Spine expects `create` and `update` actions to return the record object.

    respond_to :html, :json

    def create
      @page = Page.new(params[:page])
      if @page.save
        respond_with(@page, status: :created, location: @page)
      else
        respond_with(@page.errors, status: :unprocessable_entity) 
      end
    end

    def update
      @page = Page.find(params[:id])
      if @page.update_attributes(params[:page])
        respond_with(@page)
      else
        respond_with(@page.errors, status: :unprocessable_entity)
      end
    end
    
For a demonstration of Spine communicating with a Rails controller, see the [example application](https://github.com/maccman/spine.rails3/blob/master/app/controllers/pages_controller.rb).
    
To find out more information about Ajax & Spine, please see [its guide](<%= docs_url("ajax") %>).

##ID changes

Although Spine generates a ID for records client-side, most Rails apps will use server-side generated IDs. The latter approach has a few advantages, as server-side generated IDs are guaranteed to be unique, and usually automatically generated by the database. If you want to use a server-side generated ID, simply return it as part of the record response to the `create` action:

    # POST /pages returns:
    {"id": 1, "name": "POTUS"}
    
Spine will use the server generated ID from then on, and does some clever stuff to merge its internal ID so old ID references (such as in routes) still work.
