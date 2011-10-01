<% title 'Scrolling' %>

For a long time in iOS, scrolling was fairly broken in mobile web applications, and so it wasn't possible to have a fixed header and footer. Various JavaScript libraries, like [Joe Hewitt's Scrollability](http://joehewitt.github.com/scrollability/) were created to solve this issue by rendering the scroll bars and momentum scrolling in JavaScript. However, there's often a performance lag with these libraries, preventing the application feeling native. 

##IOS5

Fortunately this has been fixed in iOS 5, by the addition of the `-webkit-overflow-scrolling` css property. Combined with a `overflow` property, this can be used to enable native scrolling:

    .panel .content {
      -webkit-overflow-scrolling: touch;
      overflow: auto;
    }
    
As you can see in the example above, you need to set the proprietary property to `touch` in order to enable it. Unfortunately, this feature is still under development, and still fairly buggy. For now, make sure you **don't** have any children to the scrolling area with:

* `position:relative` styling
* an `:active` css selector