<% title 'Contacts Example' %>

TODO

##Setup

    npm install -g spine.app hem
    
    spine app contacts
    cd contacts
    hem server
    
##Generate
        
    spine model contact
    spine controller contacts
    spine controller contacts.main
    spine controller contacts.sidebar
    
##Contact model

    Spine = require('spine')

    class Contact extends Spine.Model
      @configure 'Contact', 'name', 'email'

      @extend @Local

      @filter: (query) ->
        return @all() unless query
        query = query.toLowerCase()
        @select (item) ->
          item.name?.toLowerCase().indexOf(query) isnt -1 or
            item.email?.toLowerCase().indexOf(query) isnt -1

    module.exports = Contact
    
##Contacts controller

    Spine   = require('spine')
    Contact = require('models/contact')
    $       = Spine.$

    Main    = require('controllers/contacts.main')
    Sidebar = require('controllers/contacts.sidebar')

    class Contacts extends Spine.Controller
      className: 'contacts'

      constructor: ->
        super

        @sidebar = new Sidebar
        @main    = new Main

        @routes
          '/contacts/:id/edit': (params) -> 
            @sidebar.active(params)
            @main.edit.active(params)
          '/contacts/:id': (params) ->
            @sidebar.active(params)
            @main.show.active(params)

        @append @sidebar, @main

        Contact.fetch()

    module.exports = Contacts
    
##Contacts main

    Spine   = require('spine')
    Contact = require('models/contact')
    $       = Spine.$

    class Show extends Spine.Controller
      className: 'show'

      events:
        'click .edit': 'edit'

      constructor: ->
        super
        @active @change

      render: ->
        @html require('views/show')(@item)

      change: (params) =>
        @item = Contact.find(params.id)
        @render()

      edit: ->
        @navigate('/contacts', @item.id, 'edit')

    class Edit extends Spine.Controller
      className: 'edit'

      events:
        'submit form': 'submit'
        'click .save': 'submit'
        'click .delete': 'delete'

      elements: 
        'form': 'form'

      constructor: ->
        super
        @active @change

      render: ->
        @html require('views/form')(@item)

      change: (params) =>
        @item = Contact.find(params.id)
        @render()

      submit: (e) ->
        e.preventDefault()
        @item.fromForm(@form).save()
        @navigate('/contacts', @item.id)

      delete: ->
        @item.destroy() if confirm('Are you sure?')

    class Main extends Spine.Stack
      controllers:
        show: Show
        edit: Edit
    
    module.exports = Main
    
##Contacts Sidebar

    Spine   = require('spine')
    Contact = require('models/contact')
    List    = require('lib/list')
    $       = Spine.$

    class Sidebar extends Spine.Controller
      className: 'sidebar'

      elements:
        '.items': 'items'
        'input': 'search'

      events:
        'keyup input': 'filter'
        'click footer button': 'create'

      constructor: ->
        super
        @html require('views/sidebar')()

        @list = new List
          el: @items, 
          template: require('views/item'), 
          selectFirst: true

        @list.bind 'change', @change

        @active (params) -> 
          @list.change(Contact.find(params.id))

        Contact.bind('refresh change', @render)

      filter: ->
        @query = @search.val()
        @render()

      render: =>
        contacts = Contact.filter(@query)
        @list.render(contacts)

      change: (item) =>
        @navigate '/contacts', item.id

      create: ->
        item = Contact.create()
        @navigate('/contacts', item.id, 'edit')

    module.exports = Sidebar