##Spine

This article introduces a new framework, [Spine Mobile](http://spinejs.com/mobile) which you can use to create awesome Mobile applications in CoffeeScript and HTML, without sacrificing the great user experience of native apps. 

Task lists and contact managers are a dime a dozen, so let's do something different in this tutorial and create a workout recorder. Users are going to be able to record workouts, including their type, time and duration. Then we're going to have a simple list showing all recorded workouts. There's also a lot of scope for further development, such as social features and graphs.

You can checkout a [live demo of the finished application here](http://spine-workout.herokuapp.com), as well as all the example's [source code, on GitHub](https://github.com/maccman/spine.mobile.workout). I highly recommend you follow along this tutorial using the source code, at least initially, as it'll help you get started if you're new to [Spine](http://spinejs.com).

If you ever need more details about [Spine Mobile](http://spinejs.com/mobile/docs), then hit up the comprehensive docs or the[ mailing list](https://groups.google.com/forum/#!forum/spinejs). For a short introduction to CoffeeScript, take a look at [The Little Book on CoffeeScript](http://arcturo.github.com/library/coffeescript/).

##Tutorial Details

* **Topic**: JavaScript Applications
* **Difficulty**: medium
* **Estimated Completion Time:** 1 hour

![Create](/images/example/create.png)

##<span>Step 1</span> Setup

First things first, we need to install some npm modules, namely `spine.app` and `hem`. The former generates Spine apps, whilst the latter acts as a dependency manager. If you haven't got them installed already, you'll need to download [Node](http://nodejs.org) and [npm](http://npmjs.org) (both sites have excellent installation guides). Then run:

    npm install -g spine.app hem
    
Now to actually generate our Spine Mobile application:
    
    spine mobile spine.workout
    cd spine.workout
    
Have a browse round the the directory structure and initial files that Spine has created for you.

    $ ls -la
    .gitignore
    Procfile
    app
    css
    package.json
    public
    slug.json
    
The `app` directory is where all the application's logic lives, such as it's models and controllers. The `public` directory is just full of static assets, and is where our application will ultimately be compiled to. It's the `public` directory that gets served up as our mobile application.
    
Our new application also has some local dependencies (specified in `package.json`), let's go ahead an install those now:
    
    npm install .
    
The last thing we need to do, is to run Spine's development server, [Hem](http://spinejs.com/docs/hem).

    hem server
    
Now the server's running, we navigate to our initial application on [http://localhost:9294](http://localhost:9294/).
    
##<span>Step 2</span> Models

In MVC frameworks, [models](http://spinejs.com/docs/models) store your application's data, and any logic associated with that data. That's it - model's shouldn't know anything else about the rest of your application; they should be completely de-coupled.

Our application needs to track workouts, recording the type of workout, how long it took, and when it took place.

So let's go ahead and create a new model:

    spine model workout
    
That'll generate a model named: `app/models/workout.coffee`. Let's open up that file and implement our `Workout` model.

    class Workout extends Spine.Model
      @configure 'Workout', 'type', 'minutes', 'date'

      @extend Spine.Model.Local

      load: ->
        super
        @date = new Date(Date.parse(@date))

      validate: ->    
        return 'type required' unless @type
        return 'minutes required' unless @minutes
        return 'date required' unless @date
        
    module.exports = Workout
    
Ok, so that's a lot of code without any explanation; let's drill down into it and look at the details.

First off we're creating a `Workout` class inheriting from `Spine.Model`, calling `@configure()` to set the model's name and attributes:

    class Workout extends Spine.Model
      @configure 'Workout', 'type', 'minutes', 'date'
      
So far so good. Now we're going to extend the model with a module named `Spine.Model.Local`. This ensures that the model data is persisted between page reloads using HTML5 Local Storage.

    @extend Spine.Model.Local
    
Now the next function, `load()`, needs a bit of an explanation. `load()` get's called multiple times internally in Spine, especially when records are serialized and de-serialized. Our issue is that we're serializing the records to JSON when persisting them with HTML5 Local Storage. However, JSON doesn't have a native 'Date' type, and just serializes it to a string. This is a problem, as we want to `date` attribute to always be a JavaScript date. Overriding `load()`, making sure the date attribute is a JavaScript `Date`, will solve this problem.

    load: ->
      super
      @date = new Date(Date.parse(@date))

Lastly we have fairly straightforward `validate()` function. In Spine, a model's validation fails if the `validate()` function return's anything 'truthy' - i.e. a string. Here we're returning `"type required"` unless the `type` exists exists. In other words, we're validating the presence of the `type`, `minutes` and `date` attributes.
      
    validate: ->    
      return 'type required' unless @type
      return 'minutes required' unless @minutes
      return 'date required' unless @date
      
You'll notice that the final line in the model is a `module.exports` assignment. This exposes the `Workout` class, so other files can require it. Spine application's use [CommonJS modules](http://spinejs.com/docs/commonjs), which requires explicit module requiring and property exporting. 

###WorkoutType model

The only other model we'll need is a `WorkoutType` model. This is just going to be a basic class, and contain a list of valid workout types. As before, we need to first generate the model:

    spine model workout_type
    
And then its contents is a simple class, containing an array of valid workout types:
  
    class WorkoutType
      @types: [
        'running'
        'jogging'
        'walking'
        'swimming'
        'tennis'
        'squash'
        'handstands'
        'skipping'
        'aerobics'
        'biking'
        'weights'
      ]

      @all: ->
        @types

    module.exports = WorkoutType
    
For more information about models, please see the [Spine models guide](http://spinejs.com/docs/models). 
        
##<span>Step 3</span> Main controllers

In Spine application's, [controllers](http://spinejs.com/docs/controllers) are the glue between models and views. They add event listeners to the view, pull data out the model and render JavaScript templates. 

The key thing you need to know about Spine's controllers, is that they're all scoped by a single element, the `el` property. Everything a controller does in its lifetime is scoped by that element; whether it's adding event listeners, responding to event callbacks, updating the element's HTML, or pulling out form data. 

Spine Mobile application's have one global `Stage` controller, which encompasses the whole screen. Let's take a look at it, in `app/index.coffee`:

    require('lib/setup')

    Spine    = require('spine')
    {Stage}  = require('spine.mobile')
    Workouts = require('controllers/workouts')

    class App extends Stage.Global
      constructor: ->
        super

        # Instantiate our Workouts controller
        new Workouts

        # Setup some Route stuff
        Spine.Route.setup(shim: true)
        @navigate '/workouts'

    module.exports = App
    
Our `App` Stage is going to be the first controller instantiated, and in charge or setting up the rest of the application. You can see, it's requiring a as-yet undefined controller named `Workouts`, and instantiated `Workouts` in the class's `constructor` function. 

In other words, when our application's first run, the `App` stage is going to be instantiated. That will in turn instantiate our `Workouts` controller, where all the action is going to be. You can also ignore all the [route stuff](http://spinejs.com/docs/routing) for the time being.

Now let's setup the aforementioned `Workouts` controller:

    spine controller workouts

The new `Workouts` controller is located under `app/controllers/workouts.coffee`. This controller is going to be where most our application lives, so let's start filling it out by replacing its contents with the following:
    
    Spine   = require('spine')
    {Panel} = require('spine.mobile')

    # Require models
    Workout     = require('models/workout')
    WorkoutType = require('models/workout_type')

    class Workouts extends Spine.Controller
      constructor: ->
        super
        
        # Our application's two Panels
        @list   = new WorkoutsList
        @create = new WorkoutsCreate

        # Setup some route stuff
        @routes
          '/workouts':        (params) -> @list.active(params)
          '/workouts/create': (params) -> @create.active(params)

        # Fetch the initial workouts from local storage
        Workout.fetch()
        
    module.exports = Workouts
    
Again, let's drill down into that and explain what's going on. Firstly, we're requiring our application's two models, `Workout` and `WorkoutType`:

    # Require models
    Workout     = require('models/workout')
    WorkoutType = require('models/workout_type')

Then `Workouts` constructor is setting up a few `Panel`s, as yet undefined, and then some routes which we can ignore for the time being. Finally, `Workout.fetch()` is being called, retrieving all the stored data from [local storage](http://spinejs.com/docs/local).
        
##<span>Step 4</span> Listing workouts

Ok, now we've done a fair bit of setting up with our `App` and `Workouts` controllers, but now comes the fun part, the panels. 

So our application has two `Panel` controllers, a list view, and a create view. These two panels belong to the main stage which ensures they transition in and out properly, only showing one panel at any one time. 

So let's first define our `WorkoutsList` controller in `app/controllers/workouts.coffee`, which, you guessed it, will list the workouts. 

    class WorkoutsList extends Panel
      title: 'Workouts'

      constructor: ->
        super
        # Add a button to the header
        @addButton('Add', @add)
        
        # Bind the model to the view
        Workout.bind('refresh change', @render)

      render: =>
        # Fetch all workout records from the model
        workouts = Workout.all()
        
        # Render a template with the workout array
        template = require('views/workouts')(workouts)
        
        # Replace the current element's HTML with the template
        @html(template)

      add: ->
        # Navigate to the 'create' controller, with a  
        # swipe transition out to the left
        @navigate('/workouts/create', trans: 'right')
            
The first thing you'll notice is that `WorkoutsList` extends `Panel`, a class defined in the `spine.mobile` package. 

Then we've got a property called `title`. This is an optional setting, and will be the title of our panel.

In the constructor function we're adding a button to the panel header by calling `@addButton(title, callback)`. When tapped, this will invoke the class' `add()` function.

Lastly we're adding binding to two events, *refresh* and *change* on the `Workout` model. Whenever the model is changed, these events will be fired, and our callback `render()` function invoked. `render()` first pulls out all the `Workout` records from the database, then renders a template, replacing the panel's contents with the result. 

So this template is just acting as a function. All we're doing is executing that function, passing in a template context, the result being the rendered DOM element. For more information on how this works, please see the [views guide](http://spinejs.com/docs/views), otherwise let's press on and define the template.

In `app/views`, create a folder called `workouts` which will contain all our templates associated with the `Workouts` controller. Then let's create a file under `app/views/workouts/index.jeco` containing:
        
      <div class="item">
        <span class="type"><%= @type %></span>
        <span class="minutes">for <%= @minutes %> mins</span>
        <span class="date">on <%= @date.toDateString() %></span>
      </div>
      
This is using a great templating library called [Eco](https://github.com/sstephenson/eco). Check out the [view guide](http://spinejs.com/docs/views) for more information on its syntax. Suffice to say, it's CoffeeScript syntax, using the `<%= %>` notation to render template variables to the page. 

The end result is a list of workouts looking like this:

![List](/images/example/list.png)
        
##<span>Step 5</span> Creating new workouts

Now the last panel to define is `WorkoutsCreate`, which will contain the form for creating new workouts. This is going to be our largest controller, but it should be fairly straightforward now you're familiar with the API and terminology. 

The only new addition here is the addition of a `elements` property, which is a convenience helper to match DOM elements to instance variables. In the example below, the elements property is set to `{'form': 'form'}`, which maps the `<form />` element to the `@form` variable. 

    class WorkoutsCreate extends Panel
      title: 'Add Workout'

      elements:
        'form': 'form'

      constructor: ->
        super
        @addButton('Back', @back)
        @addButton('Create', @create)
        
        # Render the view whenever this panel is activated,
        # resetting the form
        @bind 'active', @render()

      render: ->
        # Fetch all workout types
        types = WorkoutType.all()
        
        # Render the template, replacing the HTML
        @html require('views/workouts/form')(types: types)

      create: ->
        # Create new workout from form data
        item = Workout.create(@formData())
        
        # Navigate back to the list, if validation passed
        @back() if item

      # Navigate back to the list
      back: ->
        @form.blur()
        @navigate('/workouts', trans: 'left')

      # Retrive form data as a object literal
      formData: ->
        type    = @form.find('[name=type]').val()
        minutes = parseInt(@form.find('[name=minutes]').val())
        date    = @form.find('[name=date]')[0].valueAsDate
        {type: type, minutes: minutes, date: date}

So let's take that apart piece by piece. Firstly, in the `WorkoutsCreate` constructor, we're adding two buttons to the panel, 'Create' and 'Back'. You can probably guess what these are going to do. 

Next, we're binding to the panel's *active* event, triggered whenever the panel is shown. When the event is triggered, the `render()` function is called, replacing the controller element's HTML with a rendered template. By attaching the `render()` invocation to the *active* event, rather than directly in the constructor, we're making sure that the form is reset whenever the panel is navigated to. 

The last part to the panel is the `create()` function, where our `Workout` record is actually going to be created. We
are using `formData()` to retrieve the user's input, passing it to `Workout.create()`.

Now to define the `app/views/workouts/form.eco` template, used in the `render()` function:
        
    <form>
      <label>
        <span>Select type</span>

        <select name="type" size="1" required>
          <% for type in @types: %>
            <option value="<%= type %>"><%= type %></option>
          <% end %>
        </select>
      </label>

      <label>
        <span>Select minutes</span>

        <select name="minutes" size="1" required>
          <option value="5">5 minutes</option>
          <!-- ... -->
        </select>
      </label>

      <label>
        <span>Select date</span>
        <input name="date" type="date" required>
      </label>
    </form>

That's it for our application. Give it a whirl, and create a few workouts. 

##<span>Step 6</span> Build and deploy

The last step is to build our application to disk, and deploy it. We can do that using Hem:

    hem build

This will serialize all your JavaScript/CoffeeScript to one file (`public/application.js`), and all your CSS/Stylus (`public/application.css`). You'll need to do this before pushing your site to a remote server, so it can be served statically.

We're going to use [Heroku](http://heroku.com/) to serve our application, a great option for serving Node.js and Rails applications, and they have a generous free plan. You'll need to signup for an account with them, if you haven't got one already, as well as install the Heroku [gem](https://rubygems.org/gems/heroku).

Now, all we need to deploy our app is run a few Heroku commands to get our application deployed.

    heroku create my-spine-app --stack cedar
    git add .
    git commit -m "first commit"
    git push heroku master
    heroku open
    
Voila! You've now got a slick mobile application written in CoffeeScript, HTML5 and CSS3. We've got tons of possibilities now, such as wrapping it [PhoneGap](http://www.phonegap.com/) to access the phone's APIs, customizing the theme for Android phones or adding [offline support](http://spinejs.com/mobile/docs/offline). 

##Next steps

It may feel like a lot to learn, but we've actually covered most of [Spine's](http://spinejs.com) API in this tutorial. Why not check out the [extensive documentation](http://spinejs.com/docs), and learn a bit more about the framework?