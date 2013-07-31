
Aside from the simplest of applications, the vast majority have need of multiple views and layouts. Unfortunately, in our JavaScript web applications, we don't have the luxury of putting views on separate pages, since there's no page reloading. Instead, we need to place all the views inside the page, showing or hiding them as appropriate. 

[Spine](http://spine.github.com/spine) has a couple of utilities to help you do this, *spine.manager.js*, and *spine.list.js*.


##List

The `Spine.List` class is basically for a dynamic set of tabs populated by model data. For example, the [Spine.Contacts](https://github.com/maccman/spine.contacts) application uses `Spine.List` to render the list of contacts in the sidebar and changing the currently selected contact when clicked.

![Spine Contacts](https://lh5.googleusercontent.com/_IH1OempnqUc/TZpgYfnlUBI/AAAAAAAABKg/UYLhdmoc15o/s500/contacts.png)

As always, the first step is is to include the required libraries. We're going to need templating for rendering our list, and in this example we'll be using [jQuery.tmpl](https://github.com/jquery/jquery-tmpl). We also need to include [spine.tmpl.js](https://github.com/spine/spine/raw/master/lib/spine.tmpl.js) which includes some templating utilities. Lastly we obviously need to include [spine.list.js](https://github.com/spine/spine/raw/master/lib/spine.list.js),

    <script src="jquery.js" type="text/javascript" charset="utf-8"></script>
    <script src="jquery.tmpl.js" type="text/javascript" charset="utf-8"></script>
    <script src="spine.js" type="text/javascript" charset="utf-8"></script>
    <script src="spine.tmpl.js" type="text/javascript" charset="utf-8"></script>
    <script src="spine.list.js" type="text/javascript" charset="utf-8"></script>

As with the Spine.Contacts application, we're going to have a list of contact names in a sidebar. When users select a contact, its full information will be displayed in the main section. `Spine.List` will make that remarkably simple. It'll render the contacts list, control the currently selected contact, and trigger a *change* event when a new one is selected.

When instantiating a `Spine.List`, you need to pass in a `el` and `template` options, to indicate the element the list is associated with, and the template it should use for rendering records.

    list = new Spine.List
      el: $("#sidebar ul")
      template: (items) ->
        $("#items-template").tmpl(items)
    
The `template` option should be a function that takes records and returns DOM elements. In this example, we're calling `.tmpl()` on a inline script template. For more information on how this works, please see [jQuery.tmpl's docs](http://api.jquery.com/jquery.tmpl). 

We now need to render our list with records. Typically this is done whenever any records in the list are created, updated or destroyed. We can do this by passing a list of records to the list's `render()` function

    list.render(Contact.all())

Lastly we need to listen to *change* events, which will be invoked whenever users click on the list, changing the currently selected item.

    list.bind("change", (item) ->
      // list was changed to item!
    
That's all there is to `Spine.List`. Now let's show a full example to give you a bit of context. Firstly we're going to need two simple template, `#contacts-template` for the list and `#contact-template` for the main view. Then, as demonstrated above, we're going to render the list and listen to *change* events. When the currently selected item in the list changes, we'll re-render the main view with the newly selected record.

    <script type="text/x-template" charset="utf-8" id="contacts-template">
      <li class="item">${name}</li>
    </script>
    
    <script type="text/x-template" charset="utf-8" id="contact-template">
      <p>${name}</p>
      <!-- ... -->
    </script>

    <div id="layout2">
      <div class="sidebar">
        <ul></ul>
      </div>
      <div class="main">
      </div>
    </div>

    <script type="text/javascript" charset="utf-8">
      $ = Spine.$
      
      // Create model
      class Contact extends Spine.Model
        @configure "Contact", "name"
      
      // Create List, override default template
      SideBar = new Spine.List
        template: (items) ->
          $("#contacts-template").tmpl(items)
  
      // Create controller
      class Contacts extends Spine.Controller
        elements: {".sidebar ul": "listEl", ".main": "main"}
    
        constructor: ->
          @list = new SideBar(el: @listEl)
          @list.bind("change", @change)
          Contact.bind("refresh change", @render)

        render: ->
          @list.render(Contact.all())
          @main.html($("#contact-template").tmpl(this.current))
    
        change: (item) ->
          @current = item
          @render()
  
      new Contacts(el: $("#layout2"))
      Contact.fetch()
    </script>
    
That may look like a lot of code, but in reality it's fairly straightforward. Whenever the currently selected item in the list changes, then `Contacts.prototype.render()` function will be called, re-rendering the main view. When the application first loads, if no list items are selected then `Spine.List` will select the first item in its list. 

Like `Spine.Tabs`, `Spine.List` will add a class of *active* to the currently selected list item, which you can style with CSS to give the user a visual indication of what is currently selected.
