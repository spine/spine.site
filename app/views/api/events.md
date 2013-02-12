<% title 'Events' %>

##Class methods

### `@bind(eventNames, callback)`

Bind a event to the current context. `eventNames` can be a space separated list of event types.

    Model.bind('create update', -> )

### `@one(eventNames, callback)`

Bind an event to the current context. The handler will be executed at most once. `eventNames` can be a space separated list of event types.

    Model.one('create update', -> )

### `@on([eventNames, callback])`

Alias for .bind()

### `@off([eventNames, callback])`

Alias for .unbind()

### `@trigger(eventNames, [data...])`

Trigger events in the current context. `eventNames` can be a space separated list of event types. The optional data arguments are passed to the event callback.

### `@unbind([eventNames, callback])`

Unbind events. If called without any arguments, then all events will will un-bound. If called with only eventNames, then all those event's listeners will be un-bound. If called with a specific event name and callback, than only that callback will be removed.
