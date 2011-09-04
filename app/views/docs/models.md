<% title "Models" %>

Models are the core to Spine, and absolutely critical to your applications. Models are where your application's data is stored, and where any logic associated with that data is kept. Models should be de-coupled from the rest of your application, and completely independent. The data associated with models is stored in memory under `Model.records`.

Creating models is slightly different from creating classes, since the `create()` function is already reserved by models. Models are created with the `setup()` function, passing in the model name and an array of attributes.

    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"

Models are Spine classes, so you can treat them as such, extending and including properties.

    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"
      
      fullName: -> @first_name + " " + @last_name
    
Model instances are created with `init()`, passing in an optional set of attributes.

    contact = new Contact(first_name: "Alex", last_name: "MacCaw")
    assertEqual( contact.fullName(), "Alex MacCaw" )
    
Models can be also be easily subclassed:

    class User extends Contact
      @configure "User"
    
##Saving/Retrieving Records

Once an instance is created it can be saved in memory by calling `save()`.

    class Contact extends Spine.Model
      @configure "Contact", "first_name", "last_name"
      
    contact = new Contact(first_name: "Joe")
    contact.save()
    
When a record is saved, Spine automatically creates an ID if it doesn't already exist.

    assertEqual( contact.id, "AD9408B3-1229-4150-A6CC-B507DFDF8E90" )
    
You can use this ID to retrieve the saved record using `find()`.

    identicalContact = Contact.find( contact.id )
    assert( contact.eql( identicalContact ) )
    
If `find()` fails to retrieve a record, an exception will be thrown. You can check for the existence of records without fear of an exception by calling `exists()`.

    assert( Contact.exists( contact.id ) )
    
Once you've changed any of a record's attributes, you can update it in-memory by re-calling `save()`.

    contact = Contact.create({first_name: "Polo"})
    contact.save()
    contact.first_name = "Marko"
    contact.save()
    
You can also use `first()` or `last()` on the model to retrieve the first and last records respectively.

    firstContact = Contact.first()
    
To retrieve every contact, use `all()`.

    contacts = Contact.all()
    console.log(contact.name) for contact in contacts

You can pass a function that'll be iterated over every record using `each()`.

    Contact.each (contact) -> console.log(console.first_name)
    
Or select a subset of records with `select()`.

    Contact.select (contact) -> contact.first_name
    
##Validation

Validating models is dirt simple, simply override the `validate()` function with your own custom one.

    class Contact extends Spine.Model
      validate: ->
        unless @first_name
          "First name is required"

If `validate()` returns anything, the validation will fail and an *error* event will be fired on the model. You can catch this by listening for it on the model, notifying the user.
    
    Contact.bind "error", (rec, msg) ->
      alert("Contact failed to save - " + msg)
    
In addition, `save()`, `create()` and `updateAttributes()` will all return false if validation fails. For more information about validation, see the [form tutorial](http://maccman.github.com/spine.tutorials/form.html).

##Serialization

Spine's models include special support for JSON serialization. To serialize a record, call `JSON.stringify()` passing the record, or to serialize every record, pass the model.

    JSON.stringify(Contact)
    JSON.stringify(Contact.first())
    
Alternatively, you can retrieve an instance's attributes and implement your own serialization by calling `attributes()`.

    contact = new Contact(first_name: "Leo")
    assertEqual( contact.attributes(), {first_name: "Leo"} )
    
    Contact.include
      toXML: ->
        serializeToXML(@attributes())
    
If you're using an older browser which doesn't have native JSON support (i.e. IE 7), you'll need to include [json2.js](https://github.com/douglascrockford/JSON-js/blob/master/json2.js) which adds legacy support. 

##Persistence

While storing records in memory is useful for quick retrieval, persisting them in one way or another is often required. Spine includes a number of pre-existing storage modules, such as Ajax and HTML5 Local Storage, which you can use for persistence. Alternatively you can roll your own custom one, take a look at `spine.ajax.js` for inspiration. 

Spine's persistence is implemented via modules, so for HTML5 Local Storage persistence you'll need to include [spine.local.js](lib/spine.local.js) script in the page and for Ajax persistence you'll need [spine.ajax.js](lib/spine.ajax.js).

To persist a model using HTML5 Local Storage, simply extend it with `Spine.Model.Local`.

    class Contact extends Spine.Model
      @extend Spine.Model.Local

When a record is changed, the Local Storage database will be updated to reflect that. In order to fetch the records from Local Storage in the first place, you need to use `fetch()`. 

    Contact.fetch()
    
Typically this is called once, when your application is first initialized. 

###Using Ajax

Using Ajax as a persistence mechanism is very similar, extend models with `Spine.Model.Ajax`.

    class Contact extends Spine.Model
      @extend Spine.Model.Ajax
    
By convention, this uses a basic pluralization mechanism to generate an endpoint, in this case `/contacts`. You can choose a custom URL by setting the `url` property on your model, like so:

    class Contact extends Spine.Model
      @extend Spine.Model.Ajax
  
      url: "/users"
    
Spine will use this endpoint URL as a basis for all of its Ajax requests. Once a model has been persisted with Ajax, whenever its records are changed, Spine will send an Ajax request notifying the server. Spine encodes all of its request's parameters with JSON, and expects JSON encoded responses. Spine uses REST to determine the method and endpoint of HTTP requests, and will work seamlessly with REST friendly frameworks like Rails.

    read    → GET    /collection
    create  → POST   /collection
    update  → PUT    /collection/id
    destroy → DELETE /collection/id

For example, after a record has been created client side Spine will send off an HTTP POST to your server, including a JSON representation of the record. Let's say we created a `Contact` with a name of `"Lars"`, this is the request that would be send to the server:

    POST /contacts HTTP/1.0
    Host: localhost:3000
    Origin: http://localhost:3000
    Content-Length: 59
    Content-Type: application/json
    
    {"id":"E537616F-F5C3-4C2B-8537-7661C7AC101E","name":"Lars"}

Likewise destroying a record will trigger a DELETE request to the server, and updating a record will trigger a PUT request. For PUT and DELETE requests, the records ID is referenced inside the URL.

    PUT /tasks/E537616F-F5C3-4C2B-8537-7661C7AC101E HTTP/1.0
    Host: localhost:3000
    Origin: http://localhost:3000
    Content-Length: 60
    Content-Type: application/json
    
    {"id":"44E1DB33-2455-4728-AEA2-ECBD724B5E7B","name":"Peter"}

As you can see, the record's attributes aren't prefixed by the record's model name. This can cause problems with frameworks like Rails, which expect parameters in a certain format. You can fix this, by setting the `ajaxPrefix` option.
    
    Spine.Model.ajaxPrefix = true;
    
If `ajaxPrefix` is true, Spine will send requests like the following, prefixing all the attributes with the model name. 

    PUT /tasks/E537616F-F5C3-4C2B-8537-7661C7AC101E HTTP/1.0
    Host: localhost:3000
    Origin: http://localhost:3000
    Content-Length: 73
    Content-Type: application/json
    
    {"contact": {"id":"44E1DB33-2455-4728-AEA2-ECBD724B5E7B","name":"Peter"}}
    
It's worth mentioning here one of the major differences between Spine and other similar frameworks. All of Spine's server communication is asynchronous - that is Spine never waits for a response. Requests are sent after the operation has completed successfully client side. In other words, a POST request will be sent to the server after the record has successfully saved client side, and the UI has updated. The server is completely de-coupled from the client, clients don't necessarily need a server in order to function.

This might seem like an odd architectural decision at first, but let me explain. Having a de-coupled server offers some clear advantages. Firstly, clients have a completely non-blocking interface, they're never waiting for a slow server response for further interaction with your application. User's don't have to know, or care, about server requests being fired off in the background - they can continue using the application without any loading spinners.

The second advantage is that a de-coupled server greatly simplifies your code. You don't need to cater for the scenario that the record may be displayed in your interface, but isn't editable until a server response returns. Lastly, if you ever decided to add offline support to your application, having a de-coupled server makes this a doddle. 

Obviously there are caveats for those advantages, but I think those are easily addressed. Server-side model validation is a contentious issue, for example - what if that fails? However, this is solved by client-side validation. Validation should fail before a record ever gets sent to the server. If validation does fail server-side, it's an error in your client-side validation logic rather than with user input. 

When the server does return an unsuccessful response, an *ajaxError* event will be fired on the model, including the record, XMLHttpRequest object, Ajax settings and the thrown error. 

    Contact.bind "ajaxError", (record, xhr, settings, error) -> /* Invalid response... */ 

##Events

You've already seen that models have some events associated with them, such as *error* and *ajaxError*, but what about callbacks to create/update/destroy operations? Well, conveniently Spine includes those too, allowing you to bind to the following events:

* *save* - record was saved (either created/updated)
* *update* - record was updated
* *create* - record was created
* *destroy* - record was destroyed
* *change* - any of the above, record was created/updated/destroyed
* *refresh* - all records invalidated and replaced
* *error* - validation failed

For example, you can bind to a model's *create* event like so:

    Contact.bind "create", (newRecord) ->
      // New record was created
    
For model level callbacks, any associated record is always passed to the callback. The other option is to bind to the event directly on the record.

    contact = Contact.first()
    contact.bind "save", ->
      // Contact was updated
    
The callback's context will be the record that the event listener was placed on. You'll find model events crucial when it comes to binding records to the view, making sure the view is kept in sync with your application's data. 

##Dynamic records

One rather neat addition to Spine's models is dynamic records, which use prototypal inheritance to stay updated. Any calls to `find()`, `all()`, `first()`, `last()` etc, and model event callbacks return a *clone* of the saved record. This means that whenever a record is updated, all of its clones will immediately reflect that update.

Let's give you a code example; we're going to create an asset, and a clone of that asset. You'll notice that when the asset is updated, the clone has also automatically changed. 

    asset = Asset.create(name: "whatshisname")
    
    // Completely new asset instance
    clone = Asset.find(asset.id)

    // Change saved asset
    asset.updateAttributes(name: "bob")
    
    // Clone reflects changes
    assertEqual(clone.name, "bob")
    
This means that you never have to bother calling some sort of `reload()` functions on instances. You can be sure that all instances are constantly in sync with their saved versions.