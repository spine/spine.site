<% title 'Controllers' %>

##Class methods

### `@extend(Module)`

Add class methods; see [modules](<%= docs_path("modules") %>).

### `@include(Module)`

Add instance methods; see [modules](<%= docs_path("modules") %>)

### `sub()`

JavaScript compatibility function for creating a new controller.

    var Users = Spine.Controller.sub({
      init: function(){
        // ...
      }
    });

##Instance methods

### `el`

`@el` represents the controller's HTML element, and is instantiated when the controller is first created. Most of the controller's operations, such as `@html()` and `@append()` involve `@el`. You can think of it as the view the controller is associated with.

You also set a custom element when instantiating controllers.

    //= CoffeeScript
    new Users(el: $(".users"))

### `tag`

`@el`'s tag name. i.e. the type of element `@el` is.

By default `tag` is set to `"div"`.

    //= CoffeeScript
    class Users extends Spine.Controller
      tag: "li"

    //= JavaScript
    var Users = Spine.Controller.sub({
      tag: "li"
    });

### `className`

Classes to be set on `@el` when the controller is instantiated.

    //= CoffeeScript
    class Users extends Spine.Controller
      className: "users list"

    //= JavaScript
    var Users = Spine.Controller.sub({
      className: "users list"
    });

### `events`

You can use the `events` property instead of manually setting up event delegation. Set the `events` property to an array of object literals, in the following format: `{"eventType selector": "functionName"}`. If no selector is provided, then the event will be set directly on `@el`. Otherwise the events will be delegated to any of `@el`'s children matching the selector.

    //= CoffeeScript
    class Users extend Spine.Controller
      events:
        "click div": "click"

      click: ->
        @log("A div was clicked")

    //= JavaScript
    var Users = Spine.Controller.sub({
      events: {
        "click div": "click"
      },

      click: function(){
        this.log("a div was clicked");
      }
    });

### `elements`

Set `elements` to a hash of selectors to names. Spine will setup instances variables pointing to those elements upon the controller's instantiation. The element selectors are all scoped by `@el`.

    //= CoffeeScript
    class Users extend Spine.Controller
      elements:
        ".main": "mainElement"

      render: ->
        // mainElement is set to a jQuery element
        @mainElement.empty()

    //= JavaScript
    var Users = Spine.Controller.sub({
      elements: {
        ".main": "mainElement"
      },

      render: function(){
        this.mainElement.empty();
      }
    });

### `constructor(options = {})`

The `constructor()` function is called when the controller is instantiated and passed the controller options. You can override this, but be sure to call `super`. If you're using JavaScript, you should use the `init()` function instead; see [classes](<%= api_path("classes") %>)

    class Users extend Spine.Controller
      constructor: ->
        super
        // My other stuff

### `bind(name, function)`

Bind custom events. See [events](<%= docs_path("events") %>) for more information.

### `trigger(name, data...)`

Trigger custom events. See [events](<%= docs_path("events") %>) for more information.

### `unbind(name, [function])`

Unbind custom events. See [events](<%= docs_path("events") %>) for more information.

### `log(message)`

Append a message to the console.

    //= CoffeeScript
    class Users extend Spine.Controller
      constructor: ->
        super
        @log("Instantiated!")

    //= JavaScript
    var Users = Spine.Controller.sub({
      init: function(){
        this.log("Instantiated!");
      }
    });

### `release([function])`

If passed a function, then `release()` binds the function to the *release* events. Otherwise it fires the *release* event.

The *release* event removes `el` from the page, and unbinds all the controller's event listeners.

### `$`

A jQuery/Zepto selector, scoped to `el`.

    //= CoffeeScript
    class Users extend Spine.Controller
      render: ->
        @$(".count").html(User.count())

    //= JavaScript
    var Users = Spine.Controller.sub({
      render: function(){
        this.$(".count").html(User.count())
      }
    });

### `delay(function, delay = 0)`

Executes the given function, in the context of the controller instance, after the given delay. This is sometimes useful when dealing with browser re-drawing issues.

### `html(html)`

Replaces `@el`'s html by passing in either a piece of HTML, a jQuery element, or another controller instance. The function also ensures that `@elements` has is up to date.

### `append(elementOrController)`

Appends the given element, or controller instance, to `@el`. The function also ensures that `@elements` is up to date.

### `appendTo(elementOrController)`

Appends `@el` to the given element or controller instance.

### `prepend(elementOrController)`

Prepends `@el` to the given element or controller instance.

### `replace(element)`

Replaces `@el` with the given element, updating `@elements` and setting up the event delegation in the process.

### `proxy(function)`

A JavaScript compatibility function, which ensures that the function is always called in the context of the Controller's instance.