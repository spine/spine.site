jQuery ($) ->
  $('pre code').each ->
    text    = $(@).text()
    
    # Has a //= JavaScript comment
    return unless text.indexOf('//=') isnt -1
        
    wrap  = $('<div />').addClass('preview')
    parts = text.split(/\n?\/\/= (.+)\n/)
    parts.shift()
    
    languages = []
    scripts   = []
    for part, i in parts
      (if i % 2 is 0 then languages else scripts).push(part)
      
    csIndex = languages.indexOf('CoffeeScript')
    jsIndex = languages.indexOf('JavaScript')
      
    if csIndex isnt -1 and jsIndex is -1
      languages.push('JavaScript')
      scripts.push(CoffeeScript.compile(scripts[csIndex], bare: true))
    
    for script, i in scripts
      language = languages[i]
      code = $('<code />').text(script).attr('data-language', language)
      pre  = $('<pre />').hide().append(code)
      wrap.append pre
        
    wrap.find('pre:first').show()
    
    handle = $('<button />').addClass('handle').text('»')
    handle.attr 'title', 'Click to toggle between CoffeeScript & JavaScript'
    handle.click (e) ->
      e.preventDefault()
      wrap.find('pre').toggle()
    
    wrap.prepend handle    
    $(@).parent().replaceWith wrap