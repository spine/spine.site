<% title 'Modules' %>

##Class methods

### `@extend(properties)`

Add the specified properties as class properties.

### `@include(properties)`

Add the specified properties as instance properties.

### `@proxy(function)`

Wraps a function, so it's always executed in this class's context.

### `@init()`

A JavaScript Compatibility method. `@init()` is a noop, but can be overridden. It'll be called when the class is instantiated, with the arguments passed to the constructor function. 

##Instance methods

### `proxy(function)`

Wraps a function, so it's always executed in this class's instance context.
