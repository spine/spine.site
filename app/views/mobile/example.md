<% title 'Contacts Example' %>

Contact Model
    
    class Contact extends Spine.Model
      @configure 'Contact', 'email'
      @extend Spine.Model.Local

      @nameSort: (a, b) ->
        if (a.name or a.email) > (b.name or b.email) then 1 else -1

      validate: ->
        'Email required' unless @email
        
App Controller
        
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

    class App extends Stage.Global
      constructor: ->
        super
        @contacts = new Contacts

        Spine.Route.setup(shim:true)

List controller:

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

    class Contacts extends Spine.Controller
      constructor: -> 
        super

        @list = new ContactsList

        @routes
          '/contacts': (params) -> @list.active(params)

        Contact.fetch()
        
item.jeco
        
    <%% if @email: %>
      <p><a href="mailto:<%= @email %>"><%= @email %></a></p>
    <%% end %>
        
Show controller:

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
        
show.erb

    <div class="item">
      <%%= @email %>
    </div>
        
Create controller:

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
        
Create form:
    
    <form>
      <input type="email" name="email" placeholder="Email">
    </form>
    
