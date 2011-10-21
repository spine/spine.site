<% title 'Rails integration' %>

Spine's architecture complements Rails apps, and the two sit really well together. Rails makes a great backend API for data storage and authentication, whilst Spine provides your application with an awesome front-end and user experience. 

##Architecture

You need to decide, based on the size and complexity of your Spine app, whether you're going to base it inside your Rails project, or use something like [Hem](<%= docs_path("hem") %>) to serve it. If the app's anything more than a simple widget, I recommend the latter approach. Regardless, the integration between Spine and Rails should be limited to a JSON REST API. 

Ultimately, if you're building a full featured Spine app, Rails should become no more than an API layer, abstracting the database, ensuring validation and providing authentication. Ideally your Spine app should exist totally independently from Rails, communicating through the API. The advantage to this approach is that you get a de-coupled application, and also an API for free, which you can then open up to other developers.

I've provided an example Rails app demonstrating Spine integration here: [https://github.com/maccman/spine.rails3](https://github.com/maccman/spine.rails3)

[![Spine & Rails](https://lh5.googleusercontent.com/-I3Cig6gg0_w/ToHHN7OQg-I/AAAAAAAABaQ/Di0r0pLvitw/s400/Screen%252520Shot%2525202011-09-27%252520at%25252013.52.19.png)](https://github.com/maccman/spine.rails3)

There's also a [live demo](http://spine-rails3.herokuapp.com) of the application, go and give it [a whirl](http://spine-rails3.herokuapp.com). Notice that the UI is completely instant. There's absolutely no places where it blocks, even after creating a record. Ajax requests are sent in the background to keep the server in sync.  

If you do intend to serve up your Spine app through Rails, there are two approaches: Sprockets or Stitch. I'd recommend the former, as it's much more compliant with the 'Blessed Rails Way™', and easier to setup.

##Getting started with Sprockets

Rails uses [Sprockets](https://github.com/sstephenson/sprockets) internally to manage JavaScript and CSS assets. Spine includes support for Sprockets integration through the `spine-rails` gem. First off, add the required dependencies to your `Gemfile`:

    gem 'jquery-rails'
    
    # Optional support for jQuery templates
    gem 'sprockets-jquery-tmpl' 
    
    # Embed Spine automatically
    gem 'spine-rails'
    
Now you can use the `spine-rails` generators to create a directory structure for your Spine app. Let's do that first by running:

    rails generate spine:new

This will create the following structure for your Spine app under `app/assets/javascripts`:
    
    app
    app/lib
    app/models
    app/controllers
    app/views
    app/index.coffee

As you can see, your application is namespaced by `app`. You can specify a different namespace with the `--app` option. `spine-rails` has generated a initial `index.coffee` script that'll bootstrap your application. It's also add a require call to startup script to your `app/assets/javascripts/application.js`, so Spine will get loaded automatically.

Let's demonstrate how easily Spine integrates with Rails. First, generate a Rails scaffold:

    rails generate scaffold Post title:string content:string
    
And now let's generate a Spine Model:

    rails g spine:model Post title content
      create  app/assets/javascripts/app/models/post.coffee

Run the migrations, boot up the server, and navigate to [http://localhost:3000/posts](http://localhost:3000/posts). 

Right, let's have a play around with the Spine console and create some new records:

    var post = App.Post.create({
      title: 'Hello World!', 
      content: 'Spine & Rails, sitting in a tree!'
    });
    
    post.id; // Rails DB ID

As we're creating, updating and destroying records, so the appropriate Ajax requests are being sent to Rails, keeping the database in sync.

![JS Console](https://lh5.googleusercontent.com/-zL1pYFWsPyM/TqFrH_uY-qI/AAAAAAAABbk/rm72ewKZvvY/s600/Screen%252520Shot%2525202011-10-21%252520at%25252013.51.56.png)

If you reload the page, you'll see all the records you created were persisted. Now we can fetch the records using Spine, persisting them in memory:

    App.Post.fetch(); // Fetch records
    
    App.Post.first().content;
    
    App.Post.first().destroy();
    
Very simple indeed! As you can see, Spine works with Rails out the box. 

As well as models, `spine-rails` also lets you generate controllers and views.

    rails g spine:controller posts
      create  app/assets/javascripts/app/controllers/posts.coffee
      
    rails g spine:views posts/show

##Namespacing

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

##Cross Domain Requests

A limitation of Ajax is the same-origin policy which restricts Ajax requests to the same domain and port as the page was loaded from. This is for security reasons, due to [CSRF attacks](http://en.wikipedia.org/wiki/Cross-site_request_forgery). [Cross Origin Requests](https://developer.mozilla.org/En/HTTP_access_control), or CORS, lets you break out of the same origin policy, giving you access to authorized remote servers. 

Using CORS is trivially easy, and is just the matter of adding a few authorization headers to request responses. The specification is well supported by the major browsers, although IE ignored the spec and created it's own object, [XDomainRequest](http://msdn.microsoft.com/en-us/library/cc288060%28VS.85%29.aspx), which has a number of arbitrary [restrictions and limitations](http://blogs.msdn.com/b/ieinternals/archive/2010/05/13/xdomainrequest-restrictions-limitations-and-workarounds.aspx). Luckily, it's [easily shimed](https://github.com/jaubourg/ajaxHooks/blob/master/src/ajax/xdr.js). 

CORS support by browser:

* IE >= 8 (with caveats)
* Firefox >= 3
* Safari: full support
* Chrome: full support
* Opera: no support

###External hosts in Spine

You can specify an external host for Spine to use by setting the `Spine.Model.host` option, like so:

    Spine.Model.host = "http://api.myservice.com"
    
###CORs Rails integration
    
Let's create a `cor` method, which will add some of the request access control headers to the request's response. 

Add the following to `app/application_controller.rb`:
    
    before_filter :cor
  
    def cor
      headers["Access-Control-Allow-Origin"]  = "js-app-origin.com"
      headers["Access-Control-Allow-Methods"] = %w{GET POST PUT DELETE}.join(",")
      headers["Access-Control-Allow-Headers"] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(",")
      head(:ok) if request.request_method == "OPTIONS"
    end
    
Although `Access-Control-Allow-Origin` takes a wildcard, I highly recommend not using it as it opens up your app to all sorts of CSRF attacks. Using a whitelist is much better and more secure.
    
The `Access-Control-Allow-Headers` section is important, especially the `X-Requested-With` header. Rails doesn't like it if you send Ajax requests to it without this header, and ignores the request's `Accept` header, returning HTML when it should in fact return JSON. 

It's worth noting that jQuery doesn't add this header to cross domain requests by default. This is an issue that Spine solves internally, but if you're using plain jQuery for CORs, you'll need to specify the header manually. 

    jQuery.ajaxSetup({
      headers: {"X-Requested-With": "XMLHttpRequest"}
    });
    
Some browsers send an options request to the server first, to make sure the correct access headers are set. You'll need to catch this in Rails, returning a `200` status with the correct headers. To do this, add the following to your application's `config/routes.rb` file:
    
    match '*all' => 'application#cor', :constraints => {:method => 'OPTIONS'}

That's it, you're all set up for Cross Origin Requests with Spine!