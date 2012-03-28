<% title 'Ajax integration' %>

Spine includes a Ajax module to easily allow model data persistence via Ajax. This can then integrate with backend REST APIs, such as [Rails](<%= docs_path("rails") %>). This guide will show you the basics of using the Ajax & Spine, and then cover some of the edge cases. 

If you are integrating with Rails, you should also check out the [Rails guide](<%= docs_path("rails") %>) and [example application](https://github.com/maccman/spine.rails3). 

##Usage

To use Ajax to persistence model data, extend models with `Spine.Model.Ajax`.

    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "name"
    
      @extend Spine.Model.Ajax
      
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "name");
    
    Contact.extend(Spine.Model.Ajax);
    
By convention, this uses a basic pluralization mechanism to generate an endpoint, in this case `/contacts`. You can choose a custom URL by setting the `url` property on your model, like so:
    
    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "name"
      @extend Spine.Model.Ajax
  
      @url: "/users"
      
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "name");
    Contact.extend(Spine.Model.Ajax);
    
    Contact.extend({
      url: "/users"
    });
    
Spine will use this endpoint URL as a basis for all of its Ajax requests. Once a model has been persisted with Ajax, whenever its records are changed, Spine will send an Ajax request notifying the server. Spine encodes all of its request's parameters with JSON, and expects JSON encoded responses. Spine uses REST to determine the method and endpoint of HTTP requests, and will work seamlessly with REST friendly frameworks like Rails.

    read    → GET    /collection
    create  → POST   /collection
    update  → PUT    /collection/id
    destroy → DELETE /collection/id

For example, after a record has been created client-side Spine will send off an HTTP POST to your server, including a JSON representation of the record. Let's say we created a `Contact` with a name of `"Lars"`, this is the request that would be send to the server:

    POST /contacts HTTP/1.0
    Host: localhost:3000
    Origin: http://localhost:3000
    Content-Length: 59
    Content-Type: application/json
    
    {"id":"E537616F-F5C3-4C2B-8537-7661C7AC101E","name":"Lars"}

Likewise destroying a record will trigger a DELETE request to the server, and updating a record will trigger a PUT request. For PUT and DELETE requests, the records ID is referenced inside the URL.

    PUT /contacts/E537616F-F5C3-4C2B-8537-7661C7AC101E HTTP/1.0
    Host: localhost:3000
    Origin: http://localhost:3000
    Content-Length: 60
    Content-Type: application/json
    
    {"id":"44E1DB33-2455-4728-AEA2-ECBD724B5E7B","name":"Peter"}
    
##Server responses

Spine expects a JSON representation of the record as a server response to `create` and `update` requests. Let's look at the [Spine & Rails 3 integration example app](https://github.com/maccman/spine.rails3) for a demonstration. 

After a new `Page` record has been created, Spine sends a POST request to `/pages` containing the following:

    POST /pages HTTP/1.1
    Host: spine-rails3.herokuapp.com
    Accept: application/json, text/javascript, */*; q=0.01
    Content-Type: application/json; charset=UTF-8
    X-Requested-With: XMLHttpRequest
    Content-Length: 65

    {"name":"Dummy page","id":"EEAF4B17-5F1D-4C06-B535-D9B58D84142F"}
    
Then the server should respond with something like this:
    
    HTTP/1.1 201 Created
    Content-Type: application/json; charset=utf-8
    Location: http://spine-rails3.herokuapp.com/pages/196
    Content-Length: 28
    Connection: keep-alive

    {"name":"Dummy page","id":1}
    
Notice the ID change; the server has substituted the client-side generated ID with its own. Spine takes this all into account, and will refer to the record by its server-side ID in the future. For more information on how this works, see the [Rails integration guide](<%= docs_path("rails") %>).

##A note on API design

Ideally, when presenting an Ajax API to Spine apps, you should abstract out as much of the model data and application logic as possible. Make the API as simple as possible. When you're building APIs, it's good to get into the mindset of an API client. Approach it as if you knew nothing about the database schema or backend. What are the fundaments that you, as a client, need from the service? What's the simplest abstraction? Then you'll have a good API.

One good example is the `user_id` and `User` model relationship. A common pattern present in applications is scoping by a user. In other words, a logged in user owns a particular resource, and can only perform actions on his or her own resources. Every resource has a `user_id`, which scopes it by a particular user. This is a classic example of a relationship you don't need to expose in your API. Every request to the API already has the current logged in user specified in the session cookies - you don't need to specify it again in the API schema.

##Setting the Host

By default, Ajax requests are relative to the current domain. If your Ajax endpoint is remote, you'll need to set the `host` property:

    //= CoffeeScript
    Spine.Model.host = "http://my-endpoint"
    
This sets the `host` property globally, for all models.
    
##Fetching initial records

When your application first loads, you need to make an Ajax call, pre-populating its data. You can do this with the `fetch()` function.

    //= CoffeeScript
    Photo.fetch()
    
Usually this is done after the rest of your application has been setup, such as in the `App` controller:

    //= CoffeeScript
    class App extends Spine.Controller
      constructor: ->
        super
        # Instantiate other controllers..
        Photo.fetch()
        
    //= JavaScript
    var App = Spine.Controller.sub({
      init: function(){
        // Instantiate other controllers..
        Photo.fetch()
      }
    });
    
Calling fetch will send of an Ajax GET request to your server, and expect a response containing an array of records. Once the request has finished, the *refresh* event will be triggered. 

##Asynchronous UI

One of Spine's core values is asynchronous UIs. In a nutshell, this means that UIs should ideally never block. You shouldn't present the user with any 'loading' or 'pending' messages, everything should be pre-loaded in the backend. This is in stark contrast to other JavaScript frameworks, which block the UI whenever the user performs an action, like updating a record. 

All of Spine's server communication is asynchronous - that is Spine never waits for a response. Requests are sent after the operation has completed successfully client-side. In other words, a POST request will be sent to the server after the record has successfully saved client-side, and the UI has updated. The server is completely de-coupled from the client, clients don't necessarily need a server in order to function.

Users don't care that requests are still pending in the background, they just want a fast user interface. When I send an email, I don't want the UI to block up until the background request to the server has finished. Users don't have to know, or care, about server requests being fired off in the background - they should be able to continue using the application without any loading spinners.

The second advantage is that a de-coupled server greatly simplifies your code. You don't need to cater for the scenario that the record may be displayed in your interface, but isn't editable until a server response returns. Lastly, if you ever decided to add offline support to your application, having a de-coupled server makes this a doddle. 

###Validation

Obviously there are caveats for those advantages, but I think those are easily addressed. Server-side model validation is a contentious issue, for example - what if that fails? However, this is solved by client-side validation. Validation should fail before a record ever gets sent to the server. If validation does fail server-side, it's an error in your client-side validation logic rather than with user input. 

###Callbacks

When the server does return an unsuccessful response, an *ajaxError* event will be fired on the model, including the record, XMLHttpRequest object, Ajax settings and the thrown error. 

    //= CoffeeScript
    Contact.bind "ajaxError", (record, xhr, settings, error) -> 
      # Invalid response...
      
Likewise, when the server returns a successful response, an *ajaxSuccess* event will be fired on the record, before it's updated.

    //= CoffeeScript
    Contact.bind "ajaxSuccess", (status, xhr) -> 
      # Successful response...
      
However if you're designing your application correctly, you **shouldn't** ever need these events. Waiting for a server response goes against the whole concept of an asynchronous user interface. For example, if your server is returning extra data after a record has been created, Spine will automatically update the record with the new data. All you need to do is listen to the *save*, *update* or *change* events on the model. 

    //= CoffeeScript
    Contact.bind 'save', (contact) ->
      alert("A contact was saved: #{contact.name}")
      
    contact = new Contact(name: 'Mr Async')
    contact.bind 'save', (contact) ->
      # Called twice, once on client-side save, 
      # and once when the Ajax request completes
      alert("A particular contact was saved: #{contact.name}")
      
    contact.save()
    
There's no difference between a record being saved on the client side, and being saved in response to an Ajax request.

If you need more control over Ajax event callbacks, you should use custom requests, as detailed in the next section. 

##Custom requests

Sometimes it's necessary to do custom Ajax requests. The easiest way of doing this is by using jQuery directly inside your models:

    //= CoffeeScript
    class Photo extends Spine.Model
      @configure 'Photo', 'index'
    
      @updateOrder: ->
        indices = ({id: rec.id, index: rec.index} for rec in @all())
        $.post(@url("order"), indices)
    
    //= JavaScript
    var Photo = Spine.Model.sub();
    Photo.configure('Photo', 'index');
    
    Photo.extend({
      updateOrder: function(){
        var indices = [];
        var records = this.all();
        for(var i; i < records.length; i++) {
          var rec = records[i]
          indices.push({id: rec.id, index: rec.index});
        }
        $.post(@url("order"), indices);
      }
    });
    
As you can see, Spine provides the `url()` method, which returns a relative URL to the model:
  
    //= CoffeeScript
    assertEqual( Photo.url(), "/photos" )
    assertEqual( Photo.url("order"), "/photos/order" )
    assertEqual( Photo.first().url(), "/photos/1" )

##Ajax queue

Ajax requests are sent out serially, i.e. a request is only sent after the previous request has finished. This is to ensure data consistency without blocking up the UI. 

For example, let's say a user creates a record, and then immediately deletes it. The `DELETE` requests needs to be send after the `POST` request has finished, otherwise the server won't know what record we're talking about. 

Spine does this by having an internal queue of requests. If you want to use this queue, i.e. you have a Ajax request that needs to be sent serially alongside all the others, you can append to it like this:

    //= CoffeeScript
    Spine.Ajax.queue ->
      $.post("/posts/custom")

The callback supplied to `queue()` needs to return a jQuery Ajax object, as Spine will attach some event handlers onto it.

##Custom serialization

You may not have control over the format your servers return data in, or want to use a slightly different JSON format. That's ok, you can just override the `fromJSON()` and `toJSON()` functions. 

    //= CoffeeScript
    class Photo extends Spine.Model
      @configure 'Photo', 'index'
      @extend Spine.Model.Ajax
      
      @fromJSON: (objects) ->
        return unless objects
        if typeof objects is 'string'
          objects = JSON.parse(objects)
        
        # Do some customization...
        
        if Spine.isArray(objects)
          (new @(value) for value in objects)
        else
          new @(objects)
    
      toJSON: (objects) ->
        data = @attributes()
        # Do some customization...
        
    //= JavaScript
    var Photo = Spine.Model.sub();
    Photo.configure('Photo', 'index');
    Photo.extend(Spine.Model.Ajax);
    
    Photo.extend({
      fromJSON: function(objects) {
        if ( !objects ) return;
        if (typeof objects is 'string')
          objects = JSON.parse(objects);
          
        // Do some customization...
        
        if (Spine.isArray(objects)) {
          return objects.map(function(object){
            return new (object);
          });
        } else {
          return new this(objects);
        }
      }
    });
    
    Photo.include({
      toJSON: function(objects){
        var data = this.attributes();
        // Do some customization
        return data;
      }
    });
      
Ensure that `toJSON()` returns an object (not a JSON string), and that `fromJSON()` returns a record instance. 

##Before unload

When the user closes the page, it's possible that there are still pending requests to the server yet to be completed. Closing the page means those requests will be lost, which could lose changes the user's made. 

You can warn users of this issue by setting a *onbeforeunload* event message if requests are still pending.
  
    //= CoffeeScript
    window.onbeforeunload = ->
      if Spine.Ajax.pending
        '''Data is still being sent to the server; 
           you may lose unsaved changes if you close the page.'''

##Pagination

Sometimes your database will be so large that it's impossible to pre-load it all client-side. The solution is to pre-load a segment of the database, and then use pagination to load more data as required.

Pagination is best done with an infinite scrolling pattern, rather than showing users a list of pages. It's actually very straightforward to do. Spine's `fetch()` function takes an optional set of parameters that will be merged into the request options. All we need to do is send along the index of the last fetched record. 

    //= CoffeeScript
    class Photo extends Spine.Model
      @configure 'Photo', 'index'
      @extend Spine.Model.Ajax
      
      @fetch: (params) ->
        params or= {data: {index: @last()?.id}}
        super(params)
        
    //= JavaScript
    var Photo = Spine.Model.sub();
    Photo.configure('Photo', 'index');
    Photo.extend(Spine.Model.Ajax);
    
    Photo.extend({
      fetch: function(params){
        if ( !params && Photo.last() ) 
          params = {data: {index: this.last().id}}
        this.constructor.__super__.fetch.call(this, params);
      }
    });
    
The server can then use the `index` parameter to return the appropriate records. For example, this is how you'd do it in Rails:

    def index
      @photos = Photo.where("id > ?", params[:index] || 0).limit(30)
      respond_with(@photos)
    end
    
On the client-side, you trigger calls to `fetch()` whenever page scrolls to a certain point, perhaps using the excellent [waypoints](http://imakewebthings.github.com/jquery-waypoints/) jQuery plugin. 

    //= CoffeeScript
    $('.items').waypoint(
      -> Photo.fetch()
      offset: '90%'
    )

##Disabling Ajax

Ajax requests are sent automatically whenever any model records are created, updated or deleted. You can prevent this behavior (i.e. stopping a DELETE request going out when a record is destroyed) by using `Ajax.disable(function)`

    //= CoffeeScript
    Spine.Ajax.disable ->
      record.destroy()
      
Alternatively if you just want to disable Ajax for a single operation, you can pass the option `{ajax: false}` to the model's methods.

    //= CoffeeScript
    record.destroy({ajax: false})

If you just want the Ajax methods, without any of the automatic create/update/destroy Ajax requests, extend the model with `Spine.Model.Ajax.Methods` instead of `Spine.Model.Ajax`:
    
    //= CoffeeScript
    class Photo extends Spine.Model
      @configure 'Photo', 'index'
      @extend Spine.Model.Ajax.Methods
      
    //= JavaScript
    var Photo = Spine.Model.sub();
    Photo.configure('Photo', 'index');
    Photo.extend(Spine.Model.Ajax.Methods);

##Cross domain requests

The [Rails guide](<%= docs_path("rails_cont") %>) has a good introduction to using Spine's Ajax module with remote servers via the [CORs](https://developer.mozilla.org/En/HTTP_access_control) spec. The examples are all in Ruby, but the general concepts will apply to any language.