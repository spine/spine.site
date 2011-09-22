jQuery ($) ->
  $('pre code').each ->
    text    = $(@).text()
    
    # Has a //=JavaScript comment
    return unless text.indexOf('//=') isnt -1
        
    wrap  = $('<div />').addClass('preview')
    parts = text.split(/\n?\/\/=.+\n/)
    parts.shift()
    
    for part in parts
      code = $('<code />').text(part)
      pre  = $('<pre />').hide().append(code)
      wrap.append pre
        
    wrap.find('pre:first').show()
    
    handle = $('<button />').addClass('handle').text('»')
    handle.attr 'title', 'Click to toggle between CoffeeScript & JavaScript'
    handle.click (e) ->
      wrap.find('pre').toggle()
    
    wrap.append handle    
    $(@).parent().replaceWith wrap