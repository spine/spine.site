<% title 'Contacts Example' %>

TODO

##Setup

    npm install -g spine.app hem
    
    spine app contacts
    cd contacts
    hem server
    
##Generate models
        
    spine model contact
    spine controller contacts
    
##Contacts controller

    Spine   = require('spine')
    Contact = require('models/contact')
    Manager = require('spine/lib/manager')
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
    Manager = require('spine/lib/manager')
    $       = Spine.$

    $.fn.serializeForm = ->
      result = {}
      for item in $(@).serializeArray()
        result[item.name] = item.value
      result

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
        params = @form.serializeForm()
        @item.updateAttributes(params)
        @navigate('/contacts', @item.id)

      delete: ->
        @item.destroy() if confirm('Are you sure?')

    class Main extends Spine.Controller
      className: 'main viewport'

      constructor: ->
        super
        @show    = new Show
        @edit    = new Edit

        @manager = new Manager(@show, @edit)

        @append @show, @edit

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