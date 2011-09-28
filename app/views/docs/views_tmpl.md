<% title 'Views & Templating using jQuery.tmpl' %>

A

##Tmpl syntax

    object
      url: "http://example.com"
      getName: -> "Trevor"
    
    template = '<li><a href="${url}">${getName()}</a></li>'
    
    # Produces: <li><a href="http://example.com">Trevor</a></li>
    element = jQuery.tmpl(template, object);
    
    $("body").append(element)
    
    {{if url}}
      ${url} 
    {{/if}}
    
    {{if messages.length}}
      <!-- Display messages... --> 
    {{else}}
      <p>Sorry, there are no messages</p>
    {{/if}}
    
    object = 
      foo: "bar"
      messages: ["Hi there", "Foo bar"] 
    
    <ul>
      {{each messages}}
        <li>${$index + 1}: <em>${$value}</em></li>
      {{/each}}
    </ul>

##Compiling templates

##Data association

##Template helpers

##Binding
