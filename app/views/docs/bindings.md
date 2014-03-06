Spine has an expiremental module for automatic synchronisation of values between the elements owned by a controller (its view) and a given model.

it is simialar in concept to [Angular's two way binding](http://docs.angularjs.org/guide/databinding)

Here is a simple example of how it can be implemented in Spine:

    //= CoffeeScript
    class TestController extends Spine.Controller
      @extend Spine.Bindings
    
      modelVar: 'tmodel'
      bindings:
        '.testValue': 'field1'
    
      constructor: ->
        super
        do @applyBindings

We define the variable that should contain our model and then declare one binding. We want some element with class `testValue` to be in sync with `tmodel.field1` where tmodel is a spine model instance. Lastly you need to call method `applyBindings` somewhere in controller constructor.

The value synchronisation from the spine model depends on the `change` event. Synchronisation from the view by default depends on the [jquery's change event](http://jqapi.com/#p=change). The default way to extract value from an element is to call `$element.val()`, however there is a specific implementation for checkboxes.

Moreover, you have full control over extracting and setting element value.

    //= CoffeeScript
    class TestController extends Spine.Controller
      @extend Spine.Bindings
      
      modelVar: 'tmodel'
      bindings: 
        '.testValue': 
          field: 'field1'
          setter: (element, value) -> element.val(value)
          getter: (element) -> element.val()

In this example instead of just passing model field name we pass object where: `field1` stands for model field, `setter` is a function that invokes when model changed and we want to set a new value for an element. This function has two arguments: `element` and `value`. Also, there is function `getter` which invokes when the view element changes and we want to extract its value.

Finally, two-way binding isn't always desirable so there is a setting for making the binding go in only one direction using a `direction` parameter. It can have two values: `model` or `element`. The `model` setting means that we want to pass changes from element to model only, and we don't want to change element if model changes. The `element` setting means that we want pass changes only from model to element.
