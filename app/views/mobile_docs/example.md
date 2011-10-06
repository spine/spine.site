<% title 'Contacts Example' %>

We're going to build an example Contact manager. You can see the full source [on GitHub](https://github.com/maccman/spine.mobile.contacts), and follow along as we explain the various components.

##Model

First up, we need a `Contact` model under `app/models/contact.coffee`. This can be generated with [Spine.app](<%= docs_path("app") %>), and should look like this:

    class Contact extends Spine.Model
      @configure 'Contact', 'email'
      @extend Spine.Model.Local

      @nameSort: (a, b) ->
        if (a.name or a.email) > (b.name or b.email) then 1 else -1

      validate: ->
        'Email required' unless @email

It's extending `Spine.Model.Local`, since we want the model to be persisted with HTML5 local storage. The model also has an email attribute, which we're validating the presence of.

##Global Stage

Now let's go to the main controller, `index.coffee`. This needs to instantiate any additional controller the application needs, as well as the routing events:

    class App extends Stage.Global
      constructor: ->
        super
        @contacts = new Contacts

        Spine.Route.setup(shim:true)

##Contacts Controller

The `Contacts` controller hasn't been defined yet, so let's go ahead and do that in `app/controllers/contacts.coffee`:

    class Contacts extends Spine.Controller
      constructor: ->
        super

        @list    = new ContactsList
        @show    = new ContactsShow
        @create  = new ContactsCreate

        @routes
          '/contacts':        (params) -> @list.active(params)
          '/contacts/:id':    (params) -> @show.active(params)
          '/contacts/create': (params) -> @create.active(params)

        Contact.fetch()

As you can see, the `Contact` controller is referencing three other as-yet undefined controllers: `ContactsList`, `ContactsShow` and `ContactsCreate`. These will be sub-controllers to the `Contacts` controller, and only available inside the `contacts.coffee` script.

##ContactsList Controller

Let's go ahead and define the `ContactsList` controller. This extends from `Panel`, as defined by Spine Mobile.

    class ContactsList extends Panel
      events:
        'tap .item': 'click'

      title: 'Contacts'

      className: 'contacts list listView'

      constructor: ->
        super

        Contact.bind('refresh change', @render)
        @addButton('Add', @add).addClass('right')

      render: =>
        items = Contact.all().sort(Contact.nameSort)
        @html require('views/contacts/item')(items)

      click: (e) ->
        item = $(e.target).item()
        @navigate('/contacts', item.id, trans: 'right')

      add: ->
        @navigate('/contacts/create', trans: 'right')

In the controller's constructor, we're adding a button to the panel header called `'Add'`, that'll be used for creating additional contacts. We're also binding to the *refresh* and *change* events, calling the `render()` function. This fetches all contacts, sorts them by name, then renders the template. The template is located in `app/views/contacts/item.jeco`, and looks like this:

    <div class="item">
      <%%= @email %>
    </div>

Notice also, we're listening to *tap* events on each `.item` div, activating the `ContactsShow` controller.

##ContactsShow Controller

The `ContactsShow` controller is pretty straightforward. In a nutshell it waits for active events, finds the appropriate contact, and renders the view.

    class ContactsShow extends Panel
      className: 'contacts showView'

      constructor: ->
        super

        Contact.bind('change', @render)

        @active (params) ->
          @change(params.id)

        @addButton('Back', @back)

      render: =>
        return unless @item
        @html require('views/contacts/show')(@item)

      change: (id) ->
        @item = Contact.find(id)
        @render()

      back: ->
        @navigate('/contacts', trans: 'left')

The view is located under `app/views/contaccts/show.eco`, and just displays the contact's email.

      <%% if @email: %>
        <p><a href="mailto:<%= @email %>"><%= @email %></a></p>
      <%% end %>

##ContactsCreate Controller

Last but not least, the `ContactsCreate` controller:

    class ContactsCreate extends Panel
      elements:
        'input': 'input'

      events:
        'submit form': 'submit'

      className: 'contacts createView'

      constructor: ->
        super

        @addButton('Cancel', @back)
        @addButton('Create', @submit).addClass('right')

        @render()

      render: ->
        @html require('views/contacts/form')()

      submit: (e) ->
        e.preventDefault()
        contact = Contact.create(email: @input.val())
        if contact
          @input.val('')
          @navigate('/contacts', contact.id, trans: 'left')

      back: ->
        @navigate('/contacts', trans: 'left')

      deactivate: ->
        super
        @input.blur()

This renders a form when it's instantiated, and listens to *submit* events on that form. When the event gets fired, the contact is created and navigated to. Notice also that the form's `<input>` element is being associated with the variable `@input`, so it can be easily referenced.

And the ContactsCreate form is defined under `app/views/contacts/form.eco`:

    <form>
      <input type="email" name="email" placeholder="Email">
    </form>

##Next steps

View the full source code under [https://github.com/maccman/spine.mobile.contacts](https://github.com/maccman/spine.mobile.contacts).

You can also see the source code for [currency.io](http://currency.io) [https://github.com/maccman/spine.mobile.currency](https://github.com/maccman/spine.mobile.currency).