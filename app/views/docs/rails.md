<% title 'Rails integration' %>

##Architecture

Splitting up Frontend/API

##Stitch

    gem 'stitch-rb'

    match '/application.js' => Stitch::Server.new(:paths => ["app/assets/javascripts"])
    

##Sprockets

##Ajax
