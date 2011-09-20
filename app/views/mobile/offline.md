<% title 'Offline' %>

Adding offline functionality to your app can be as trivial or difficult as you want it to be, depending on how much scope you give your users. Read-only applications, that don't need to save user input, are the easiest to add offline support to. However, it's possible, but trickier, to add support to read-write applications too. 

This is the sort of decision you should make at the start of building your app, rather than something you can tack on later. It can be an integral part of the application's architecture, and not a decision you want to put off. 

##HTML5 Offline

The Spine Mobile [currency convertor example](https://github.com/maccman/spine.mobile.currency) is a classic case for adding offline support. It's a read-only application, and the conversion rates should be valid for the next few days. When the application loads up, it sends off an Ajax call to a remote server fetching the current conversion rates. In order for the application to work offline, we need to cache a temporary copy of this data, along with the application's assets (javascript/css etc). 

Fortunately this is extremely trivial to do with [HTML5's Offline support](http://diveintohtml5.org/offline.html). First, we need to make a `cache.manifest` file, which will live in the `public` directory of our app:

    CACHE MANIFEST
    # v1.0.4
    NETWORK:
    *
    CACHE:
    ./application.js
    ./application.css
    ./index.html
    http://currency-proxy.herokuapp.com/currencies
    
The manifest file needs to start with `CACHE MANIFEST` to be valid. Next you can see two sections, a `NETWORK` section, and a `CACHE` one. 

The network section is a whitelist of resources that need a network connection to be accessed; we'll set that to `*` - every resource, by default, should be fetched remotely. Then, the cache section is a whitelist of assets that need to be cached locally in order for the application to work correctly. Notice that we're also adding the remote JSON endpoint for the currency data. 

Now, in order to get the manifest working, we need to link to it from `index.html`:

    <!DOCTYPE html>
    <html manifest="/cache.manifest">
    <head>
    <!-- ... -->

That's all there is to it! The next time our application is used, the browser will download and cache it locally (including the currency data). From then on, the browser will use the local copy of the application, even if a internet connection is available. Every time the application startups, the browser will check to see if the cache manifest file has changed. If it has, it'll re-download all the assets, and swap the cache over the next time the application's started.

In other words, to update the local cache, you'll need to:

1. Change the `cache.manifest` file by incrementing the version number (touching it's mtime isn't sufficient).
1. Reload the application.
1. Wait several seconds for the assets to re-download, then reload it again.

That's quite a workflow, so I suggest adding HTML5 Offline support towards the end of development.

##Syncing

If you need more intelligent caching, like support for read-write operations, you'll need to take a different route (or combine the two). As well as a local copy of the data, you'll need to record changes to it. Whilst offline, your application should record all CUD (Create, Update, Destroy) operations at the model layer. Then, once online:

1. Re-play stored CUD operations against the server (as Ajax requests)
1. Reload all data

This is a much simpler solution than trying to add full syncing (and merging) capabilities to your application. The more complicated you make something, the more likely it is to fail. In addition, users don't understand merging screens; you should make an intelligent decision on their behalf (just copying the data if needs be).

Spine will include a module to help with all of this in the near future.