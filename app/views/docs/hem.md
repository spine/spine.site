<% title 'Using Hem' %>

[Hem](https://github.com/maccman/hem) is an dependency management tool for JavaScript Web apps; you can think of it as Bundler for Web Apps, resolving all the dependencies and compiling your application up to be served to clients.

Hem is excellent for developing Spine, and indeed any type of JavaScript applications. It'll manage your application's CoffeeScript, JavaScript and CSS, compiling them to disk upon deployment. 

##Installation

First, if you haven't got it installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Then, to install Hem:

    npm install -g hem
    
Hem will now be available globally under the `hem` executable. Now, there are few things you need to understand about Hem before we go any further.

##Dependencies

Hem has two types of dependency resolutions: Node modules and Stitch. 

##CommonJS

[CommonJS](<%= docs_path("commonjs") %>)

##Slug.json

    {
      // Specify main JavaScript file:
      "main": "./app/index",
      
      // Specify main CSS file:
      "css": "./css/index.less",
      
      // Specify public directory:
      "public": "./public"
      
      // Add load paths:
       "paths": ["./app"]
      
      // We want these to load before (not CommonJS libs):
       "libs": [
         "./lib/other.js"
       ]
    }

##Usage

    hem server
    hem build

##Heroku

    hem build
    git add ./public
    git commit -m 'version x'
    git push heroku master
