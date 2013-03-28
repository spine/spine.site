<% title 'Routing' %>

Spine provides application routing based on the URL's hash fragment, for example the URL `http://example.com/#/users` has the hash fragment `/users`. Hash fragments can be completely arbitrary and don't trigger page reloads, maintaining page state. Your application can also be indexed by hash fragments using Google's [Ajax Crawling specification](http://code.google.com/web/ajaxcrawling/index.html).

Internally Spine uses the *hashchange* event to detect changes in the URLs hash. This event has only been developed recently, and is only available in newer browsers. To support antiquated browsers, you can use the excellent [jQuery hashchange plugin](http://benalman.com/projects/jquery-hashchange-plugin/), which emulates the event using iframes and other clever trickery. 

##Adding routes

So, how to use the API? It's very simple. First you need to include [route.coffee](https://raw.github.com/maccman/spine/master/src/route.coffee), which contains the module `Spine.Route`. Then you can start adding routes inside your controller. `Spine.Route` gives you a `routes()` function inside controllers, which you can call passing a hash of routes and callbacks.

    //= CoffeeScript
    class App extends Spine.Controller
      constructor: ->
        @routes
          "/users/:id": (params) ->
            console.log("/users/", params.id)
          "/users": ->
            console.log("users")
            
    //= JavaScript
    var App = Spine.Controller.sub({
      init: function(){
        this.routes({
          "/users/:id": function(params){
            console.log("/users/", params.id)
          },
          
          "/users": function(){
            console.log("users")
          }
        })
      }
    });

Route parameters, are in the form of `:name`, and are passed as arguments to the associated callback. You can also use globs to match anything via an asterisk, like so: 

    //= CoffeeScript
    @routes
      "/pages/*glob": (params) ->
        console.log("/pages/", params.glob)

Routes are added in reverse order of specificity, so the most specific routes should be added first, and generic 'catch alls' should be added later. It's worth noting, especially if you're putting routes in the `constructor()` function of controllers, that routes shouldn't be added more than once. The examples above are fine, since the `App` controller is only ever going to be instantiated a single time. 

One alternative is to skip out controllers, and add routes directly using `Spine.Route.add()`, passing in either a hash or a single route. 
    
    //= CoffeeScript
    Spine.Route.add /\/groups(\/)?/, -> console.log("groups")
    
Like you can see in the example above, routes can also be raw regexes, giving you full control over matching.

##Initial Setup

When the page loads initially, even if the URL has a hash fragment, the `hashchange` event won't be called. It'll only be called for subsequent changes. This means, after our application has been setup, we need to manually tell Spine that we want to run the routes & check the URL's hash. This can be done by invoking `Spine.Route.setup()`.
    
    //= CoffeeScript
    Spine.Route.setup()
    
##Navigate
    
Lastly, Spine gives controllers a `navigate()` function, which can be passed a fragment to change the URL's hash. You can also pass `navigate()` multiple arguments, which will be joined by a forward slash (`/`) to create the fragment. 

    //= CoffeeScript
    class Users extends Spine.Controller
      constructor: ->
        # Navigate to #/users/:id
        @navigate("/users", @item.id)
    
    new Users(item: User.first())
    
    //= JavaScript
    var Users = Spine.Controller.sub({
      init: function(){
        this.navigate("/users", this.item.id);
      }
    });
    
    new Users({item: User.first()});
    
Using `navigate()` ensures that the URL's fragment is kept in sync with the relevant controllers. By default, calling `navigate()` will trigger route callbacks. If you don't want to trigger routes, pass a `false` boolean as the last argument to `navigate()`.
    
    //= CoffeeScript
    # Don't trigger routes by passing false
    Spine.Route.navigate("/users", false)

##HTML5 History

Spine also gives you the option of using HTML5's History API, which has the advantage of being able to alter the url without a page refresh or using hash fragments. This means cleaner URLs in a format your users are accustomed to. 

To use the History API, instead of hash fragments, pass `{history: true}` to `setup()`:

    //= CoffeeScript
    Spine.Route.setup(history: true)
    
HTML5 History support will only be enabled if this option is present, and the API is available. Otherwise, Spine's routing will revert back to using hash fragments. 

However, there are some things you need to be aware of when using the History API. Firstly, every URL you send to `navigate()` needs to have a real HTML representation. Although the browser won't request the new URL at that point, it will be requested if the page is subsequently reloaded. In other words you can't make up arbitrary URLs, like you can with hash fragments; every URL passed to the API needs to exist. One way of implementing this is with server side support. 

When browsers request a URL (expecting a HTML response) you first make sure on server-side that the endpoint exists and is valid. Then you can just serve up the main application, which will read the URL, invoking the appropriate routes. For example, let's say your user navigates to `http://example.com/users/1`. On the server-side, you check that the URL `/users/1` is valid, and that the User record with an ID of `1` exists. Then you can go ahead and just serve up the JavaScript application. 

The caveat to this approach is that it doesn't give search engine crawlers any real content. If you want your application to be crawl-able, you'll have to detect crawler bot requests, and serve them a 'parallel universe of content'. That is beyond the scope of this documentation though. 

##Shimming

Sometimes it's convenient to use routes, without any changes to the page's URL or hash fragment. This is an especially common scenario in full-screen mobile or PhoneGap applications, where the page's address isn't even displayed. To cater for this, `Route.setup()` takes a `shim` option; for example:
    
    //= CoffeeScript
    Spine.Route.setup(shim: true)

##Zepto Disclaimer

*our current tests for Spine v1.1 do not show routing as fully functional with zepto.js*
