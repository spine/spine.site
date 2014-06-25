<% title 'Routing' %>

##Class methods

### `@historySupport`

Boolean indicating whether the browser support the HTML5 History API or not.

### `@setup(options = {})`

Setup the route events. This should be done in the application's main controller, after the rest of the app has been loaded.

Takes the following options:

* `trigger: true` - fires a route event immediately if necessary
* `history: false` - use HTML5 local history (if available)
* `shim: false` - just route internally (don't use the page's path)
* `replace: false` - use history.replaceState() instead of .pushState()

### `@add(path, callback)`

Add a route. The `path` argument can either be a regex, or a string in the following format: `/contacts/:id`, where `id` is a route parameter.

When the callback function is invoked, it gets passed an object containing the appropriate route parameters.

### `@navigate(parts..., [options])`

Navigate to the supplied relative URL. If given multiple arguments, the arguments are joined with a forward slash.

    Route.navigate('/contacts', contact.id) #=> /contacts/1

The last argument can be an `options` object. Supported options are:

* `trigger: true` - trigger route callbacks

##Controller methods

Controllers are extended with following instance methods:

### `routes(object)`

Add a set of routes. Callbacks are executed in the current context:

    @routes
      "/contacts/id": -> #...
      "/contacts":    -> #...

### `navigate(url, [data])`

Alias for `Route.navigate()`.
