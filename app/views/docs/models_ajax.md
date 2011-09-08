<% title 'Models Ajax' %>

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