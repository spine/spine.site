<% title 'Models API' %>

##Class methods

### `@configure(modelName, attributes...)`

Set up the model and its attributes. This is required for every model, and should be called before anything else is. 

    class User extends Spine.Model
      @configure "User", "first_name", "last_name"

### `@include(Module)`

Add class methods; see [modules](<%= docs_path("modules") %>).
    
### `@extend(Module)`
    
Add instance methods; see [modules](<%= docs_path("modules") %>)

### `@bind(eventName, function)`

Bind event listeners to the model. These are executed in the context of the model.

    User.bind("refresh change", (user) -> alert("#{user.name} changed!"))
    
### `@trigger(eventName, data...)`
    
Trigger a custom event

### `@unbind([eventName, function])`
    
Unbind events, see the [events guide](<%= docs_path("events") %>) for more information. 
    
### `@records`
    
An hash of the raw saved record instances. You shouldn't need to access or alter this directly. 

### `@attributes`
    
An array of model attributes, set using `@configure`. You shouldn't need to access or alter this directly.

### `@toString()`
    
Convenience function for representing the model.

### `@find(id)`
    
Find records by ID - returning the record instance. If the record doesn't exist, this function will throw an error.
    
### `@exists(id)`
    
Returns a boolean indicating if the record with the specified ID exists or not.
    
### `@refresh(recordsArray, [options])`
    
Appends to all the stored records, without calling any *create*, *update*, *save* or *destroy* events. The only event that will be triggered is the *refresh* event. You can pass the option `{clear: true}` to wipe all the existing records. Internally `@refresh` calls ``
    
replace: true
    
### `@select(function)`
    
### `@findByAttribute(name, value)`

### `@findAllByAttribute(name, value)`

### `@each(callback)`

### `@all()`

### `@first()`

### `@last()`

### `@count()`

### `@deleteAll()`

### `@destroyAll()`

### `@update(id, attributes)`

### `@create(attributes)`

### `@destroy(id)`

### `@change([function])`

### `@fetch([function])`

### `@toJSON()`

### `@fromJSON(json)`
   
###  `@proxy(function)`

Wrap a function in a proxy so it will always execute in the context of the model. 
    
### `@setup(name, [attributes...])`


    
##Instance methods

### `newRecord`
### `isNew()`
### `isValid()`
### `validate()`
### `load(attributes)`
### `attributes()`
### `eql(record)`
### `save()`
### `updateAttribute(name, value)`
### `updateAttributes(attributes)`
### `changeID(id)`
### `destroy()`
### `dup()`
### `clone()`
### `reload()`
### `toJSON()`
### `toString()`
### `exists()`
### `bind(name, function)`
### `trigger(name, [data...])`
### `unbind()`
### `proxy(function)`