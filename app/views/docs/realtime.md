<% title 'Realtime Spine' %>

One advantage of using the MVC and Binding patterns is that making your application realtime is a piece of cake. All the server needs to do is inform client-side models of data changes, and the client's interface will be updated automatically. We can do this easily using a project I wrote called [Juggernaut](https://github.com/maccman/juggernaut). 

Juggernaut is basically realtime PubSub for web apps. Browsers subscribe to channels, and servers publish to them. Juggernaut will do the rest, negotiating the best type of realtime connection with the server dependent on browser support. It'll first try WebSockets, and then fallback to Comet and polling. 

I've built an [application demonstrating this](https://github.com/maccman/spine.rails3/tree/fowa) and you can also see a [live example here](http://spine-fowa.herokuapp.com).

There's also a [short screencast](<%= pages_path("screencasts") %>) explaining how to integrate Spine with [Pusher](http://pusher.com), a hosted WebSocket server.

##Usage

Let's implement a Juggernaut handler. It'll subscribe to the `/observer` channel, and then process observer events. During processing, it tries to find the model the message is associated with, then creates, updates or destroys records as necessary. 
    
    //= CoffeeScript
    #= require juggernaut
    
    $ = jQuery

    class JuggernautHandler
      constructor: (@options = {}) ->
        @jug = new Juggernaut(@options)
        @jug.subscribe '/observer', @processWithoutAjax

      process: (msg) =>
        klass = window[msg.class]
        throw 'Unknown class' unless klass
        switch msg.type
          when 'create'
            klass.create msg.record unless klass.exists(msg.record.id)
          when 'update'
            klass.update msg.id, msg.record
          when 'destroy'
            klass.destroy msg.id
          else
            throw 'Unknown type:' + type

      processWithoutAjax: =>
        args = arguments
        Spine.Ajax.disable =>
          @process(args...)

    $ -> new JuggernautHandler(host: 'localhost', port: 8080)
    
    //= JavaScript
    var JuggernautHandler = Spine.Class.sub({
      init: function(options) {
        if ( !options ) options = {};
        this.jug = new Juggernaut(options);        
        this.jug.subscribe('/observer', this.proxy(this.processWithoutAjax));
      },
      
      process: function(msg){
        var klass;
        klass = window[msg["class"]];
        if ( !klass ) throw 'Unknown class';
        switch (msg.type) {
          case 'create':
            if (!klass.exists(msg.record.id)) {
              return klass.create(msg.record);
            }
            break;
          case 'update':
            return klass.update(msg.id, msg.record);
          case 'destroy':
            return klass.destroy(msg.id);
          default:
            throw 'Unknown type:' + type;
        }
      },
      
      processWithoutAjax: function(){
        var args;
        args = arguments;
        return Spine.Ajax.disable(this.proxy(function() {
          return this.process.apply(this, args);
        }));
      }
    });
    
    jQuery(function(){ new JuggernautHandler({host: 'localhost', port: 8080}); });
    
That's pretty straightforward. So, the messages we broadcast to Juggernaut need to look like this:

    {
      "type": "create",
      "class": "Page",
      "id": "1",
      "record": {"name": "First one!"}
    }
    
We can create this server-side, broadcasting it to Juggernaut whenever a record changes. For example, we could use Juggernaut's Ruby adapter in Rails to integrate with ActiveRecord models. Here we're using an observer to record whenever the `Page` model changes.
    
    class JuggernautObserver < ActiveRecord::Observer
      observe :page

      def after_create(rec)
        publish(:create, rec)
      end

      def after_update(rec)
        publish(:update, rec)
      end

      def after_destroy(rec)
        publish(:destroy, rec)
      end

      protected
        def publish(type, rec)
          Juggernaut.publish(
            "/observer",
            { 
              type:   type, 
              id:     rec.id, 
              class:  rec.class.name, 
              record: rec
             }
          )
        end
    end
    
Once the record has changed, the `publish` method is called. This method publishes a message to the `/observer` channel, pushing it out to all the connected clients.

##Next steps

For more information on Juggernaut, and its installation, please see the [project's README](https://github.com/maccman/juggernaut). I also recommend checking out the source of the [example Rails & Spine integration application](https://github.com/maccman/spine.rails3/tree/fowa), as this uses Juggernaut for its realtime models. 