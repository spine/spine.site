<% title 'Rails integration' %>

Spine's architecture complements Rails apps, and the two sit really well together. 

##Architecture

Spine and Rails communicate to each other using Ajax, REST and JSON. 

Spine app

Splitting up Frontend/API

[https://github.com/maccman/spine.rails3](https://github.com/maccman/spine.rails3)

[http://spine-rails3.herokuapp.com/](http://spine-rails3.herokuapp.com/)

##Prefixing

When sending JSON requests, Spine doesn't prefix any of it's data with the model name. For examp

    {"user": {name: "Sam Seaborn"}}
    
And Spine will send something that looks like this:
    
    {"name": "Sam Seaborn"}

Rails 3.1 has added support for unpreffixed parameters by default... `config/initializers/wrap_parameters.rb`

    ActionController::Base.wrap_parameters format: [:json]

    # Disable root element in JSON by default.
    if defined?(ActiveRecord)
      ActiveRecord::Base.include_root_in_json = false
    end

##Sprockets

    gem 'jquery-rails'
    gem 'sprockets-jquery-tmpl'
    gem 'spine-rails', :git => 'git://github.com/maccman/spine-rails.git'

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

##Stitch

    gem 'stitch-rb'

    match '/application.js' => Stitch::Server.new(:paths => ["app/assets/javascripts"])

##Ajax

##ID change
