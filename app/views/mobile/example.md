<% title 'Contacts Example' %>

    class ContactsList extends Panel
      events:
        'tap .item': 'click'

      className: 'contacts list listView'

      constructor: ->
        super

        Contact.bind('refresh change', @render)
        @addButton('Add Contact', @add)

      render: =>
        items = Contact.all()
        @html require('views/contacts/item')(items)

      click: (e) ->
        item = $(e.target).item()
        @navigate('/contacts', item.id, trans: 'right')

      add: ->
        @navigate('/contacts/create', trans: 'right')