<% title 'Using forms' %>

Forms are a staple part of almost every web application, so it's important to know how to manipulate them, fetch data and update models. 

##Capturing form events

The first step is actually capture the form's *submit* event, so we know when a user wants to submit a form. The easiest way of doing this, is with Spine's controllers `events` option, for example:

    class Contacts extends Spine.Controller
      events: 
        "submit form.contactForm": "create"
      
      create: (e) ->
        // Form submitted
    
    new Contacts(el: $("body"))

The `events` property ensures that all *submit* events on the matching form are captured, calling the create function. Now, by default, forms cause a page reload. This is definitely not the behavior we want, since the page reloads, we've lost all state. Rather, we're going to send any required requests to the server using Ajax.

To ensure the form doesn't reload the page, we're going to need to cancel the 'default event'. This is easily done on the event object passed to our  `create()` function.

    class Contacts extends Spine.Controller
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        // Form stuff

Calling `preventDefault()` on the event prevents the default action, and is preferable to the alternative of returning `false` from the function. The latter approach cancels event propagation (something we could need later), and makes debugging extremely difficult if any code inside the event callback throws errors. 

##Retrieving form data

So, now we know when forms are being submitted, but how about actually retrieving the data contained inside the form. We could manually go through every input element in the form, reading their value, but we're lazy so let's automate it!

[jQuery](http://jquery.com) has a rather useful function called `serializeArray()` ([documented here](api.jquery.com/serializeArray/)), which serializes forms based on their input's name and values. However, the returned result looks like this, and can't be directly used with Spine:

    [{name: "first_name", value: "Alex"}, {name: "last_name", value: "MacCaw"}]
    
Let's create a plugin to jQuery which adds an additional function, `serializeForm()`.

    $.fn.serializeForm = ->
      result = {}
      for item in $(@).serializeArray()
        result[item.name] = item.value
      result
    
This function basically takes the data returned from jQuery's `serializeArray()` and transforms it into a more useful format:

    {first_name: "Alex", last_name: "MacCaw"}
    
Let's put everything together so you can see how form serialization works in context.

    class Contacts extends Spine.Controller
      elements: {"form.contactForm": "form"}
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        data = @form.serializeForm()

##Updating a record

Updating a record is now trivial, we have the data, all we need is the record. If you're using the [*element pattern*](http://maccman.github.com/spine#s-patterns-the-element-pattern), then you've already got a local reference to the record. All you need to do now is call `create()` or `updateAttributes()` depending on whether you want to create a record, or update an existing one.

    class Contacts extends Spine.Controller
      elements: {"form.contactForm": "form"}
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        data    = @form.serializeForm();
        contact = Contact.create(data);

If, on the other hand, you don't have a local reference to the record at hand, you'll have to get one. If you're using [jQuery.tmpl](http://api.jquery.com/category/plugins/templates/) templating library, you can see which record an HTML element is associated with, by calling `tmplItem()`.

However, unfortunately the format this function returns isn't exactly what we need, so let's add an additional function to jQuery.tmpl called `item()`:

    $.fn.item = ->
      item = $(this).tmplItem().data
      item.reload() if $.isFunction(item.reload)
    
Now we can just call `item()` on a HTML element to retrieve the record it's associated with.

    class Contacts extends Spine.Controller
      events: 
        "submit .item form": "update"
      
      update: (e) ->
        e.preventDefault()
        data = $(e.target).serializeForm()
        item = $(e.target).item()
        item.updateAttributes(data)
      
##Adding validation

Validation is dirt simple, and leaves you a lot of flexibility in how you display error messages to users. Firstly, to add validation to your models, you need to override the model's instance function called `validate()`. Essentially, if `validate()` returns anything, validation fails. Let's see how we'd validate the presence of a `first_name` attribute on a model:

    class Contact extends Spine.Model
      @configure "Contact", "first_name"
      
      validate: ->
        "First name is required" unless @first_name
    
So, if the record's `first_name` is missing or an empty string, `validate()` will return a message and validation will fail (empty strings coerce to `false` in JavaScript).

In your controller's, you can cater for failing validation by checking to see if the record is valid before you save it:

    if item.save()
      // Coolio...
    else
      msg = item.validate()
      alert(msg)

`save()` and `updateAttributes()` both return `false` if validation fails. `validate()` returns the actual error message. In the example above we're doing the simplest possible thing, opening an alert box containing the validation failure message. You may want to display more information to users, such as highlight the relevant inputs. This you can do by returning an object from `validate()`, specifying which attributes are at fault and their associated error messages. 
