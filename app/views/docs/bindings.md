Spine has an expiremental module for automatic synchronisation values between the elements owned by a controller and a given model.

Here is a simple example of how it should work:

```coffee
class TestController extends Spine.Controller
  @extend Spine.Bindings
  
  modelVar: 'tmodel'
  bindings:
    '.testValue': 'field1'

  constructor: ->
    super
    do @applyBindings
```

We define the variable that should contain our model and then declare one binding. We want some element with class `testValue` to be in sync with `tmodel.field1` where tmodel is a spine model instance. Lastly you need to call method `applyBindings` somewhere in controller constructor.

The value synchronisation from the spine model depends on the `change` event. Synchronisation from the view by default depends on the DOM inputs 'onChange' event. The default way to extract value from an element is to call `$element.val()`, however there is a specific implementation for checkboxes.

Moreover, you have full control over extracting and setting element value.

```coffee
  TestController extends Spine.Controller
    @extend Spine.Bindings

    modelVar: 'tmodel'
    bindings: 
      '.testValue': 
        field: 'field1'
        setter: (element, value) -> element.val(value)
        getter: (element) -> element.val()
```

In this example instead of just passing model field name we pass object where: `field1` stands for model field, `setter` is a function that invokes when model changed and we want to set a new value for an element. This function has two arguments: `element` and `value`. Also, there is function `getter` which invokes when the view element changes and we want to extract its value.

Additionaly, a `direction` parameter can be passed. It can have two values: `model` and `element`. The `model` setting means that we want to change the value of model only. The `element` setting means that we want to change only element value.
