<% title 'PhoneGap' %>

[PhoneGap](http://www.phonegap.com) is a great way of turning your Spine Mobile apps into native applications, giving them more integration into the device, and allowing them to be sold on the iOS App Store, for example. 

This guide will only cover the specifics of PhoneGap and Spine Mobile integration. For more information about setting up PhoneGap, and its API, see [its documentation](http://www.phonegap.com/start).

##Build Phase

Firstly, we need to compile our application to disk using [Hem](<%= docs_path("hem") %>), like so:

    hem build

Next, PhoneGap has a `www` directory which we'll need to replace. I recommend generating a new PhoneGap application in a folder called `./build/ios` inside your Spine application. Then, open up the PhoneGap project in XCode, and edit the "Touch www folder" build phase, to replace it with a `cp` command relating to the Spine app's public directory, as demonstrated in the screenshot:

![Compiling](https://lh4.googleusercontent.com/-TxijdXkmWck/TniKQBwvYwI/AAAAAAAABZk/yZgiIjpXJ-M/s800/Screen%252520Shot%2525202011-09-20%252520at%25252013.42.05.png)

Now, whenever XCode compiles your PhoneGap application, the `public` directory will be copied over automatically. You'll just need to remember to run `hem build` before every XCode build (or add that as a build phase).

##PhoneGap lib

PhoneGap requires `phonegap.js` to be included in your application. In the future the script will be injected automatically, but for now you need to include it manually. The script is generated when you create a new PhoneGap application (in the `www` folder), and needs to be copied into the Spine application and  specified in the app's `slug.json` file, like so:

    {
      "dependencies": [
        "es5-shimify", 
        "json2ify", 
        "jqueryify", 
        "gfx",
        "spine",
        "spine/lib/local",
        "spine/lib/ajax",
        "spine/lib/manager",
        "spine/lib/route",
        "spine/lib/tmpl"
      ],
      "libs": [
        "./lib/phonegap.js",
      ]
    }

##Next steps

PhoneGap & Spine integration is in its early stages at the moment, so requires a fair bit of setting up. If you've having any issues, ask a question on the mailing list. 