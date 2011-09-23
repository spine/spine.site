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
      code = $('<code />').text(script)
      pre  = $('<pre />').append(code).addClass(language)
      wrap.append pre
    
    handle = $('<button />').addClass('handle').text('»')
    handle.attr 'title', 'Click to toggle between CoffeeScript & JavaScript'
    handle.click (e) ->
      e.preventDefault()
      wrap.find('pre').toggle()
    
    wrap.prepend handle    
    $(@).parent().replaceWith wrap
    
  # Preview select
  select = $('<select />').attr('id', 'preview')
  select.append($('<option />').text('CoffeeScript'))
  select.append($('<option />').text('JavaScript'))
  select.change ->
    $('body').removeClass('CoffeeScript JavaScript')
    $('body').addClass($(@).val())
    $.cookie('preview', $(@).val())
    
  select.val($.cookie('preview'))
  select.change()

  $('body').prepend select