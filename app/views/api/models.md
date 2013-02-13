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
    
See [events](<%= docs_path("events") %>) for more information. 
    
### `@trigger(eventName, data...)`
    
Trigger a custom event, see [events](<%= docs_path("events") %>) for more information.

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

    user = User.find("1")
    
### `@exists(id)`
    
Returns a boolean indicating if the record with the specified ID exists or not.

    user = User.exists("1")
    alert(user.name) if user
    
### `@refresh(recordsArray, [options])`
    
Appends to all the stored records, without calling any *create*, *update*, *save* or *destroy* events. The only event that will be triggered is the *refresh* event. You can pass the option `{clear: true}` to wipe all the existing records. Internally `@refresh` calls `fromJSON()`, so you can also pass it JSON instead of an array.

    User.refresh([{id: 1, name: "test"}, {id: 2, name: "test2"}])
    
### `@select(function)`

Select all records that the callback function returns true to. 

    bobs = User.select (user) -> user.name == "bob"
    
### `@findByAttribute(name, value)`

Find the first record that has the given attribute & value.

    bob = User.findByAttribute("name", "bob")

### `@findAllByAttribute(name, value)`

Find all records that have the given attribute & value.

    bobs = User.findAllByAttribute("name", "bob")

### `@each(callback)`

Iterate over every record, passing it to the callback function.

    User.each (user) -> alert(user.name)

### `@all()`

Returns a cloned copy of every instance.

    users = User.all()

### `@first()`

Return the first record.

### `@last()`

Returns the last record.

### `@count()`

Returns the count of total records.

### `@deleteAll()`

Deletes every record without triggering any events.

### `@destroyAll(options)`

Destroys every record, triggering a *destroy* event on every record.

### `@update(id, attributes)`

Updates the record with the matching ID, with the given attributes.

### `@create(attributes)`

Creates a new record with the given attributes. Returns `false` if the record's validation fails, or the newly created record if successful. 

### `@destroy(id, options)`

Destroys the record with the given ID.

### `@change([function])`

If passed a function, `@change()` adds that function as a listener to the *change* event. Otherwise, it triggers the *change* event.

### `@fetch([function])`

If passed a function, `@fetch()` adds that function as a listener to the *fetch* event. Otherwise, it triggers the *fetch* event.

### `@toJSON()`

Utility function so the model has a valid JSON representation (shows all records).

### `@fromJSON(json)`

Pass a JSON string, representing either an array or a singleton, to `@fromJSON()`. Returns an array or unsaved model instances. 

### `@fromForm(formElement)`

Returns a new record, populated by the given HTML form's inputs.
   
###  `@proxy(function)`

Wrap a function in a proxy so it will always execute in the context of the model. This is a JavaScript compatibility feature, and shouldn't be used in CoffeeScript.

    create = Model.proxy(Model.create)
    
### `@setup(name, [attributes...])`

Alternative method for creating a new model class. This is a JavaScript compatibility feature, and shouldn't be used in CoffeeScript.

    var User = Model.setup("User", ["first_name", "last_name"])
    
##Instance methods

### `newRecord`

Boolean indicating if the record has been saved or not. Use `isNew()` instead.

### `isNew()`

Returns a boolean indicating if the record has been saved or not.

### `isValid()`

Returns a boolean indicating if the record has passed validation.

### `validate()`

By default a noop. Override this to provide custom validation. Return a string, containing the error message, if the record isn't valid. For example:

    class User extends Spine.Model
      @configure "User", "name"
      
      validate: ->
        "Name required" unless @name

### `load(attributes)`

Load a set of properties in, setting attributes.

    user = new User
    user.load(name: "Sir Bob")

### `attributes()`

Returns a hash of attributes to values.

### `eql(record)`

Returns a boolean indicating if the other record is equal (i.e. same class and ID) as the current instance.

    if user.eql(anotherUser)
      alert("Yah!")

### `save()`

Creates or updates the record, returning `false` if the record's validation fails, or `self` if the record saves successfully. During a save, the *beforeSave*, *change* and *save* events are triggered. Also the *create* or *update* events will be fired depending on whether the record was created/updated.

    user = new User(name: "Sir Robin")
    user.save()
    
    alert("#{user.id} was saved")
    user = User.find(user.id)

### `updateAttribute(name, value)`

Sets a single attribute, saving the instance.

    user = new User
    user.updateAttribute("name", "Green Knight")

### `updateAttributes(attributes)`

Updates a record with the given attributes, saving the record. 

    user = User.create()
    user.updateAttributes(name: "Sir Galahad the Pure")

### `destroy()`

Destroys the record, removing it from the record store and triggering the *destroy* event.

    user = User.create()
    user.destroy()

### `dup()`

Returns a new unsaved record, with the same attributes as the current record, save the ID, which will be `null`. 

    user = User.create(name: "Sir Bedevere")
    dup  = user.dup()
    assertEqual( dup.name, "Sir Bedevere" )

### `clone()`

Returns a prototype clone of the record. This is used internally for *Dynamic Records*, and is probably not something you need to worry about.

### `reload()`

Reloads a record's attributes from its saved counterpart. 

### `toJSON()`

Returns the record's attributes. This is used for JSON serialization:

    record = new User(name: "Sir Lancelot the Brave")
    
    assertEqual( JSON.stringify(record), '{"id":"foo","name":"Sir Lancelot the Brave"}' )
    
    $.post("/record.json", JSON.stringify(record))

### `toString()`

Returns a string representation of the record. A utility function used to display the record in the console.

### `exists()`

Returns a boolean indicating whether the record has saved. Similar to `isNew()`, but it actually checks the models record store.

### `fromForm(formElement)`

Populates the record's attributes with inputs from the given HTML form.

### `bind(name, function)`

Bind to an event specifically on this record. 

### `trigger(name, [data...])`

Trigger an event specifically on this record. This will propagate up to the model too. 

### `unbind()`

Unbind all events.

### `proxy(function)`

A JavaScript compatibility function, that will wrap the given function so that it's always executed in the context of the record.
