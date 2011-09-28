<% title 'Forms & Validation' %>

Forms are a staple part of almost every web application, so it's important to know how to manipulate them, fetch data and update models. Likewise, validation is just as important, and it's likely you'll need some sort of validation for every model. 

This guide will explain about the whole of this process, such as how to handle form information, update records, and validate models.

##Capturing form events

The first step is actually to capture the form's *submit* event, so we know when a user wants to submit a form. The easiest way of doing this, is with Spine's controllers `events` option, for example:

    //= CoffeeScript
    class Contacts extends Spine.Controller
      events: 
        "submit form.contactForm": "create"
      
      create: (e) ->
        # Form submitted
    
    new Contacts(el: $("body"))
    
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      events: {
        "submit form.contactForm": "create"
      },
      
      create: function(e) {
        // Form submitted
      }
    });
    
    new Contacts(el: $("body"))

The `events` property ensures that all *submit* events on the matching form are captured, calling the create function. Now, by default, forms cause a page reload. This is definitely not the behavior we want, since the page reloads, we've lost all state. Rather, we're going to send any required requests to the server using Ajax.

To ensure the form doesn't reload the page, we're going to need to cancel the 'default event'. This is easily done on the event object passed to our  `create()` function.

    //= CoffeeScript
    class Contacts extends Spine.Controller
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        # Form stuff
        
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      events: {"submit form.contactForm": "create"},
      
      create: function(e) {
        e.preventDefault();
        // Form stuff
      }
    });

Calling `preventDefault()` on the event prevents the default action, and is preferable to the alternative of returning `false` from the function. The latter approach cancels event propagation (something we could need later), and makes debugging extremely difficult if any code inside the event callback throws errors. 

##Retrieving form data

So, now we know when forms are being submitted, but how about actually retrieving the data contained inside the form. We could manually go through every input element in the form, reading their value, but we're lazy so let's automate it!

[jQuery](http://jquery.com) has a rather useful function called `serializeArray()` ([documented here](api.jquery.com/serializeArray/)), which serializes forms based on their input's name and values. However, the returned result looks like this, and can't be directly used with Spine:

    [{name: "first_name", value: "Alex"}, {name: "last_name", value: "MacCaw"}]
    
Let's create a plugin to jQuery which adds an additional function, `serializeForm()`.

    //= CoffeeScript
    $.fn.serializeForm = ->
      result = {}
      for item in $(@).serializeArray()
        result[item.name] = item.value
      result
    
This function basically takes the data returned from jQuery's `serializeArray()` and transforms it into a more useful format:

    {first_name: "Alex", last_name: "MacCaw"}
    
Let's put everything together so you can see how form serialization works in context.

    //= CoffeeScript
    class Contacts extends Spine.Controller
      elements: {"form.contactForm": "form"}
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        data = @form.serializeForm()
        
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      elements: {"form.contactForm": "form"},
      events: {"submit form.contactForm": "create"},
      
      create: function(e) {
        e.preventDefault();
        var data = @form.serializeForm();
      }
    });

##Updating a record

Updating a record is now trivial, we have the data, all we need is the record. If you're using the [*element pattern*](http://maccman.github.com/spine#s-patterns-the-element-pattern), then you've already got a local reference to the record. All you need to do now is call `create()` or `updateAttributes()` depending on whether you want to create a record, or update an existing one.

    //= CoffeeScript
    class Contacts extends Spine.Controller
      elements: {"form.contactForm": "form"}
      events: {"submit form.contactForm": "create"}
      create: (e) ->
        e.preventDefault()
        data    = @form.serializeForm();
        contact = Contact.create(data);
        
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      elements: {"form.contactForm": "form"},
      events: {"submit form.contactForm": "create"},
      
      create: function(e) {
        e.preventDefault();
        var data = @form.serializeForm();
        var contact = Contact.create(data);
      }
    });

If, on the other hand, you don't have a local reference to the record at hand, you'll have to get one. If you're using [jQuery.tmpl](http://api.jquery.com/category/plugins/templates/) templating library, you can see which record an HTML element is associated with, by calling `tmplItem()`.

However, unfortunately the format this function returns isn't exactly what we need, so let's add an additional function to jQuery.tmpl called `item()`:

    //= CoffeeScript
    $.fn.item = ->
      item = $(this).tmplItem().data
      item.reload() if $.isFunction(item.reload)
    
Now we can just call `item()` on a HTML element to retrieve the record it's associated with.

    //= CoffeeScript
    class Contacts extends Spine.Controller
      events: 
        "submit .item form": "update"
      
      update: (e) ->
        e.preventDefault()
        data = $(e.target).serializeForm()
        item = $(e.target).item()
        item.updateAttributes(data)
        
    //= JavaScript
    var Contacts = Spine.Controller.sub({
      events: {"submit form.contactForm": "update"},
      
      update: function(e) {
        e.preventDefault();
        var data = @form.serializeForm();
        var item = $(e.target).item();
        item.updateAttributes(data);
      }
    });
      
##Adding validation

Validation is dirt simple, and leaves you a lot of flexibility in how you display error messages to users. Firstly, to add validation to your models, you need to override the model's instance function called `validate()`. Essentially, if `validate()` returns anything, validation fails. Let's see how we'd validate the presence of a `first_name` attribute on a model:

    //= CoffeeScript
    class Contact extends Spine.Model
      @configure "Contact", "first_name"
      
      validate: ->
        "First name is required" unless @first_name
        
    //= JavaScript
    var Contact = Spine.Model.sub();
    Contact.configure("Contact", "first_name");
    
    Contact.include({
      validate: function(){
        if ( !this.first_name )
          return "First name is required";
      }
    });
    
So, if the record's `first_name` is missing or an empty string, `validate()` will return a message and validation will fail (empty strings coerce to `false` in JavaScript).

In your controllers, you can cater for failing validation by checking to see if the record is valid before you save it:

    //= CoffeeScript
    unless item.save()
      msg = item.validate()
      return alert(msg)

`save()` and `updateAttributes()` both return `false` if validation fails. `validate()` returns the actual error message. In the example above we're doing the simplest possible thing, opening an alert box containing the validation failure message. You may want to display more information to users, such as highlight the relevant inputs. This you can do by returning an object from `validate()`, specifying which attributes are at fault and their associated error messages. 

##Form validation

Validation for form inputs in HTML5 is fairly straightforward. If a field is required, simply set `required` on the `<input />` element. Likewise, modern browsers, such as Chrome and Firefox, validate the format of email addresses given to email inputs.

    <form>
      <input type="text" name="name" value="${name}" required autofocus>
      <input type="email" name="email" value="${email}" required>
    </form>
    
When the form is submitted, if the validation fails then messages will be shown by the inputs to help users rectify the situation. 

![Validation](https://lh3.googleusercontent.com/-lPyyIM3cYFs/ToMCYzC0UoI/AAAAAAAABaY/bqYi8BnKK08/s800/Screen%252520Shot%2525202011-09-28%252520at%25252012.17.18.png)

You can specify your own validation messages using the `:invalid` css pseudo selectors. For more information about HTML5 form validation, see the following articles:

* [http://www.matiasmancini.com.ar/jquery-plugin-ajax-form-validation-html5.html](http://www.matiasmancini.com.ar/jquery-plugin-ajax-form-validation-html5.html)
* [http://www.alistapart.com/articles/forward-thinking-form-validation](http://www.alistapart.com/articles/forward-thinking-form-validation/)
* [http://diveintohtml5.org/forms.html](http://diveintohtml5.org/forms.html)

For older browsers that don't support HTML5 validation, you'll need to use a shim. I can recommend the [jQuery.HTML5FORM](http://www.matiasmancini.com.ar/jquery-plugin-ajax-form-validation-html5.html) plugin.

##Server-side validation

If possible, all validation should be done on the client-side. However sometimes this isn't possible, especially with validating the uniqueness of a value. It's a tricky problem, and Spine doesn't have a good solution for this scenario yet. 

You have a choice, either block the form whilst the Ajax request to the server is pending, displaying a validation error if the request fails. Or alternatively, you can validate the input before the form has been submitted with a background Ajax request.

For example, during the [Twitter](http://twitter.com) signup process, the username field validates before the form is submitted, as soon as the username input is unfocused.

![Validate uniqueness](https://lh4.googleusercontent.com/-XNnmzWmhacU/ToMJHIIUgGI/AAAAAAAABag/RRzrjQMmtRo/s800/Screen%252520Shot%2525202011-09-28%252520at%25252012.45.42.png)

As I mentioned earlier, it's best to avoid uniqueness validation if at all possible. Most web applications will only need it at the user registration stage, and I suggest you leave registration and authentication to a backend service like Rails, rather than use Spine. 