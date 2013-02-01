<%- title 'Local Storage and Models' %>

Spine has support for [HTML5 Local Storage](http://diveintohtml5.org/storage.html) to persist model data between page reloads. Local Storage is a quick and simple way of storing data, and the vast majority of modern browsers support it (Chrome, Firefox 3.5+, IE 8+, and mobile browsers). It's great for offline applications too. 

*Note: The stock browser of Android 2.3 or earlier has a bug related to parsing JSON which means you should make sure you are using a [shim](https://github.com/douglascrockford/JSON-js) if you are targeting that browser.*

Browsers give each 'origin' or domain at least 5mb of data by default. If you exceed this storage quota than the `QUOTA_EXCEEDED_ERR` exception will be thrown. 

##Usage

To persist a model using HTML5 Local Storage, simply extend it with `Spine.Model.Local`.
    
    //= CoffeeScript
    class Contact extend Spine.Model
      @configure "Contact", "name"
      @extend Spine.Model.Local
      
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "name");
    Contact.extend(Spine.Model.Local);
    
When a record is changed, the Local Storage database will be updated to reflect that. In order to fetch the records from Local Storage in the first place, you need to use `fetch()`.

    //= CoffeeScript
    Contact.fetch()
    
When the data has been successfully fetched from local storage, the *refresh* event will be triggered. You should bind to this event in your controllers, re-rendering the views as appropriate. 

    //= CoffeeScript
    Contact.bind 'refresh', @render
    
    //= JavaScript
    Contact.bind('refresh', this.proxy(this.render))
