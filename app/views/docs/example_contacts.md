<% title 'Contacts Example' %>

This example will show you how to use Spine, Hem and Eco to build a basic contacts manager.

Some of the source will be omitted for the sake of brevity (such as the CSS). You can find the complete source on GitHub, as well as a live demo. This is what we'll end up with:

![Spine Contacts](https://lh5.googleusercontent.com/_IH1OempnqUc/TZpgYfnlUBI/AAAAAAAABKg/UYLhdmoc15o/s500/contacts.png)

Before we get started, I advise you to do the following:

* Gain a basic understanding of [CoffeeScript](http://jashkenas.github.com/coffee-script)
* Read the [Introduction to Spine](<%= docs_path("introduction") %>)
* Skim the guides on the main Spine classes, such as [Models](<%= docs_path("models") %>) and [Controllers](<%= docs_path("controllers") %>)

Now you've got all that under your belt, let's think about what we need in this Contact's application from a high level architectural standpoint.

* A Contact model to store and persist contacts
* A way of creating contacts
* Listing contacts
* Editing existing contacts
* Deleting contacts

Basically your classic CRUD methods. Let's get started!

##Setup

Firstly, to make life easier, we're going to install [Spine.app](<%= docs_path("app") %>) and [Hem](<%= docs_path("hem") %>). Spine.app is a Spine application generator. It's not required to use Spine, but very useful all the same. Hem is bit like Bundler for JavaScript apps, see their respective guides for more information.

If you haven't got them installed already, you'll need [Node](http://nodejs.org) and [npm](http://npmjs.org). Both projects' sites include excellent installation instructions. Now we can get on with installing the two npm modules we need, `spine.app` and `hem`:

    npm install -g spine.app hem
    
Now we've got an executable called `spine` which we can use to generate new applications. 
    
    spine app contacts
    cd contacts

Check out the article on [Spine.app](<%= docs_path("app") %>) for more information concerning its usage. Now let's install the default dependencies listed in our application's `package.json`:

    npm install .
    
Finally we can use the `hem` executable to run a Hem server, which will temporarily host our Spine application during development.

    hem server
    
Now our server is running, let's open up the application:

    open http://localhost:9294
    
You'll see Spine's default welcome screen introducing you to the framework. Let's remove that before we go any further. Open up `public/index.html`, and remove the 'getting started' script tag:

    <!-- Getting started script - should be removed -->
    <script src="http://maccman-spine.herokuapp.com/start.js" type="text/javascript" charset="utf-8"></script>
    
Refresh the page, and it should be blank.
    
##Generate

Let's generate the basic models and controller's our applications going to need. Firstly, a `Contact` model:

    spine model contact
    
This will generate a model under `app/models/contact.coffee` which will come in handy later. Then let's generate three controllers, `Contacts`, `ContactsMain` and `ContactsSidebar`.
    
    spine controller contacts
    spine controller contacts_main
    spine controller contacts_sidebar
    
These controller's will be created under `app/controllers.` We could put all the controllers inside one file, but by splitting them up we're de-coupling them, ensuring our code is clear and doesn't descend into Spaghetti hell. 

##Contact model

So earlier we generated a `Contact` model. Let's flesh that out, and add some functionality. Replace `app/models/contact.coffee` with the following:

    Spine = require('spine')

    class Contact extends Spine.Model
      # Configure name & attributes
      @configure 'Contact', 'name', 'email'
      
      # Persist with Local Storage
      @extend @Local

      @filter: (query) ->
        return @all() unless query
        query = query.toLowerCase()
        @select (item) ->
          item.name?.toLowerCase().indexOf(query) isnt -1 or
            item.email?.toLowerCase().indexOf(query) isnt -1

    module.exports = Contact
    
Ok, so that need's some explaining. Let's take that apart piece by piece. Firstly, we're calling `configure()`, passing in the name of the model and its attributes. This is something you'll need to do whenever you create a model, and it should be done immediately before anything else inside the model. As you can see, our `Contact` model is going to have two attributes, a `name` and an `email`.

The next line ensures our model is persisted with HTML5 Local Storage. Spine's Local Storage module is included by default in our generated application, so this line is all that's required to make sure that model data is persisted between page reloads.

The last part of the model is a class (static) function called `filter()`. This takes a query string and returns an array of contacts that match that string, comparing both the email address and name of each contact stored in the model. This function will come in handy in our sidebar, allowing us to filter the list of contacts easily. 

Lastly the model is exported, so it's available to be required from other modules.
    
##ContactsMain

Right, now out model is setup we can move onto the controllers. Let's tackle the `ContactsMain` controller first. Replace the contents of `app/controllers/contacts_main.coffee` with the following:

    Spine   = require('spine')
    Contact = require('models/contact')
    $       = Spine.$
    
That sets up some variables we're going to use, such as the `Contact` model and jQuery. 

The main section of our application is going to have two main 'views', a show view and an edit view. This will translate into two controller's `Show` and `Edit` respectively. We want to make sure only one of these controller is shown at any one time, so we're going to use a [Stack](<%= docs_path("stack") %>) to manage them.

So let's go ahead and implement the `Show` controller, appending the following to `app/controllers/contacts_main.coffee`:

    class Show extends Spine.Controller
      # Set the HTML class
      className: 'show'

      events:
        'click .edit': 'edit'

      constructor: ->
        super
        
        # Bind the change() callback
        # to the *change* event
        @active @change

      render: ->
        # Render a template, replacing the 
        # controller's HTML
        @html require('views/show')(@item)

      change: (params) =>
        @item = Contact.find(params.id)
        @render()

      edit: ->
        # Navigate to the 'edit' view whenever
        # the edit link is clicked
        @navigate('/contacts', @item.id, 'edit')
        
So, the first property in `Show` is `className`, which set a class of `show` on the controller's internal HTML element. This will help us style the controller later. 

Next we're setting up some events, specifically a *click* event on any element with a class of `edit`. In this case, our template is going to contain a `<a class="edit">Edit</a>` link which, when clicked, will invoke the controller's `edit()` function, navigating to the edit route.

In the controller's constructor, we're binding to the *active* event, specifying the `change()` function as a callback. We're going to pass some router params when triggering the event, which will be used by our callback to find the relevant contact, and then re-render the view. This part will make more sense when you see how the controller is activated later on in the tutorial.

Notice in the `render()` function we're requiring a template under `views/show`, calling it and passing in the current item. Let's go ahead now and define that template. Create a file under `app/views/show.eco` containing the following:

    <header>
      <a class="edit">Edit</a>
    </header>

    <div class="content">
      <p><%= @name %></p>
      <p><%= @email %></p>
    </div>

This is an [eco](<%= docs_path("views") %>) template, and the syntax inside the template tags (`<%%= %>`) is CoffeeScript. We're pulling out the `name` and `email` properties from the contact, displaying them in the page. We've also got that edit link we talked about earlier, ready to be clicked.

###Edit controller

No we've defined our `Show` controller which will show us information about the selected contacts, we can go ahead and define an `Edit` controller for updating contacts. Append the following to `app/controllers/contacts_main.coffee`.

    class Edit extends Spine.Controller
      className: 'edit'

      events:
        'submit form': 'submit'
        'click .save': 'submit'
        'click .delete': 'delete'

      elements: 
        'form': 'form'

      constructor: ->
        super
        @active @change

      render: ->
        @html require('views/form')(@item)

      change: (params) =>
        @item = Contact.find(params.id)
        @render()

      submit: (e) ->
        e.preventDefault()
        @item.fromForm(@form).save()
        @navigate('/contacts', @item.id)

      delete: ->
        @item.destroy() if confirm('Are you sure?')
        
In a lot of ways, this is really similar to the `Show` controller. We're binding to the *active* active event with a `change()` callback, rendering a template with the appropriate contact context. The only real difference here is there's a few more events, mostly dealing with the controller's form. When the form submits, the `submit()` callback will be invoked and the item updated from the form's inputs (using `fromForm()`).

Again, we're requiring a template under `views/form`, rendering it with the current contact (`@item`). Let's define that template under `app/views/form.eco`:

    <header>
      <a class="save">Save</a>
      <a class="delete">Delete</a>
    </header>

    <div class="content">
      <form>
        <label>
          <span>Name</span>
          <input type="text" name="name" value="<%= @name %>">
        </label>

        <label>
          <span>Email</span>
          <input type="email" name="email" value="<%= @email %>">
        </label>  

        <button>Save</button>
      </form>
    </div>
    
It's pretty self explanatory; again we're just pulling out properties from the current context using the `<%%= %>` syntax.

###Main Stack

The last step for our `ContactsMain` controller, is to define a stack that will manage our other two controllers, `Show` and `Edit`. Both controllers, `Show` and `Edit`, need to be shown independently one at a time. A  

    class Main extends Spine.Stack
      controllers:
        show: Show
        edit: Edit
    
    module.exports = Main
    
##Contacts Sidebar

    Spine   = require('spine')
    Contact = require('models/contact')
    List    = require('spine/lib/list')
    $       = Spine.$

    class Sidebar extends Spine.Controller
      className: 'sidebar'

      elements:
        '.items': 'items'
        'input': 'search'

      events:
        'keyup input': 'filter'
        'click footer button': 'create'

      constructor: ->
        super
        @html require('views/sidebar')()

        @list = new List
          el: @items, 
          template: require('views/item'), 
          selectFirst: true

        @list.bind 'change', @change

        @active (params) -> 
          @list.change(Contact.find(params.id))

        Contact.bind('refresh change', @render)

      filter: ->
        @query = @search.val()
        @render()

      render: =>
        contacts = Contact.filter(@query)
        @list.render(contacts)

      change: (item) =>
        @navigate '/contacts', item.id

      create: ->
        item = Contact.create()
        @navigate('/contacts', item.id, 'edit')

    module.exports = Sidebar
    

##Contacts controller

    Spine   = require('spine')
    Contact = require('models/contact')
    $       = Spine.$

    Main    = require('controllers/contacts_main')
    Sidebar = require('controllers/contacts_sidebar')

    class Contacts extends Spine.Controller
      className: 'contacts'

      constructor: ->
        super

        @sidebar = new Sidebar
        @main    = new Main

        @routes
          '/contacts/:id/edit': (params) -> 
            @sidebar.active(params)
            @main.edit.active(params)
          '/contacts/:id': (params) ->
            @sidebar.active(params)
            @main.show.active(params)

        @append @sidebar, @main

        Contact.fetch()

    module.exports = Contacts