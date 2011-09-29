<% title 'Testing Applications' %>

Testing Spine applications is simple if focus is set on isolating the application logic from the framework plumbing code and on testing the custom code that the DOM, Model or Custom events will trigger.
Spine customization works by a user providing callback functions to handle different phases in Models (creation, deletion, validation), Controllers (initialization, rendering, DOM events) and Routing (pattern matching routes handling)
You shouldn't test the Spine framework itself, such as testing that Spine does proxies the methods specified in the proxied attribute, how Spine serializes objects or how Spine formats and creates Ajax or HTML5 Storage requests from your models.
Avoiding side effects of tested function should be done by stubbing any code that isn't relevant for the exact expectation we mean to check in a specific test. For this end, one could use Jasmine spying mechanism, as can be seen in later examples.

Examples here will be given using snippets that use the [Jasmine](http://pivotal.github.com/jasmine/) testing framework syntax, but these snippets can be easily ported into other browser-based Javascript testing frameworks.

##Testing Models

###Persistence

	Persistence, either using Ajax or  HTML5 Local Storage, isn't that interesting from a testing perspective since Spine does the heavy lifting for you. To disable persistence while testing, fake Spine's persistence adapters - 
		Spine.Model.Local = {};
		Spine.Model.Ajax = {};

###Events

	Testing for event handling should be done by unit testing the callback functions that are provided to the Model bind function. This will allow for some separation of the application logic from the framework and will make the code easier to test (including 	testing error handling and edge cases). Executing the callback functions as if the event they are binded to has been fired and then testing that they fulfill their expectations is the proper way to test event handling with Models.
	Since most of the event binding on Models is done in the Controller, an example of testing Model event handlers it will be covered in the Controllers section.

###Iterating

	We really want to test the callback evaluator function - 

    //= JavaScript
		draw_first = function(con) { 
			canvas.draw(con.first_name); // canvas.draw is an imaginary API just for this example
		}

		spyOn(canvas, "draw");
		var contact = Contact.init( { first_name: "Alex" } );
		draw_first(contact);
		expect(canvas, draw).toHaveBeenCalledWith("Alex");

	The former way is preferable and concise over trying to test the entire iterating mechanism, since it's simply more verbose - 
 
    //= JavaScript
		Contact.include({
			draw_first: function(con){
				canvas.draw(con.first_name);
		});
		
		var alex_contact = Contact.init({first_name: "Alex"});
		var john_contact = Contact.init({first_name: "John"});
		alex_contact.save();
		john_contact.save();
		spyOn(canvas, draw);
		
		Contact.each(Contact.draw_first);
		expect(canvas, draw).toHaveBeenCalledWith("Alex");
		expect(canvas, draw).toHaveBeenCalledWith("John");

	Now you can use the is_friend function safely with the select function. If you want to be really through, test your controller code so that it calls the Model's select method appropriately, supplying the is_friend method as the callback argument.

###Selecting

	Same as with iterating - 

    //= JavaScript
		is_friend = function(con) {
			return con.friend;
		}
		var contact = Contact.init( { first_name: "John", friend: true } );
		expect(is_friend(contact)).toBeTruthy();	


###Validation

	Validating that certain model fields exist or given in a certain form is done by providing a custom validation function.
	The same logic from before applies here and to test validation we can unit test the validation function alone or rather instantiate the Model under test and provide values that should and should not pass validation. 

	If validation fails, an error event will be fired and you should test that validation errors are handled properly as you will test any other event - you can test the error handling function by triggering the error event on the model -

	Or, again, by defining a error handling function as the handler instead of providing an anonymous function and then unit testing it -

	When validation fails, calling the Model save and updateAttributes methods (most likely from some Controller code) will return false. You can then call the Model validation function again to get more information on what happened.
	If you wish to simulate this situation, either try to save a Model with invalid fields -

    //= JavaScript
		var contact = Contact.init({first_name: "Some", phone: "Invalid Phone Number"});
		contact.save()

	Or stub the validation function using a Jasmine Spy -
    
    //= JavaScript
		var contact = Contact.init({first_name: "Some", last_name: "Name"});
		spyOn(contact, "validate").andCallFake(function() { return 'Phone number validation error' });
		contact.save();

	This will trigger the error handling branch in your Controller code.


##Testing Controllers

###Initialization

	The init method is called on instantiation and is the suitable place for binding any custom event handlers using the bind method. The binding of DOM events on the root element or it's children is done by specifying events and handlers in the events 	property. As such, testing a Controller's  initialization phase will include instantiating the controller and then checking that both custom and DOM events 	were binded to handlers properly.

	Spying on the Controller's bind method and setting expectations on the events we would like to handle and their handlers -

		var ToggleView = Spine.Controller.Create({
			init: function() {
				this.bind("toggle", this.toggle);
			},
			toggle: function() { /* … */ },
			bind: jasmine.createSpy('bindSpy');
		});
		var view = ToggleView.init();
		expect(view.bind).toHaveBeenCalledWith("toggle");

	In most cases you will want to test an existing Controller, and in that case you should - 
	
		ExistingToggleView.extend( { bind: jasmine.createSpy('bindSpy'); } )
		var view = ToggleView.init();
		expect(view.bind).toHaveBeenCalledWith("toggle");


###Events

	Continouing with our approach, testing should be done by simulating the event by executing the handler function with appropriate arguments. Since Spine automatically sets the context of DOM event handlers, by default it is possible to use a controller instance properties 	from within the handlers.
		
		Controller under test: 

    //= JavaScript
		var TasksView = Spine.Controller.Create({
			events: { "click .task" : "click" }, 
			init: function() { Contact.bind( "create", this.proxy(this.notify) ); },
			click: function(e) {
				canvas.draw("Task for " + this.user + ": " + e.target.text()),
			},
			notify: function(item) {
				canvas.draw("Task that is due on  " + item.date +  " created!");
			 },
			user: current_user.get("name");
		});

		The test: 

    //= JavaScript
		var view = TasksView.init();
		spyOn(canvas, "draw");
		var fake_event = { target: { text: function() { return "Learn about testing with Spine";  }  };
		view.user = "John";
		view.click(fake_event);
		expect(canvas.draw).toHaveBeenCalledWith("Task for John: Learn about testing with Spine");

	Testing Model handlers is done in the same way -

		The test: 

    //= JavaScript
		var view = TasksView.init();
		spyOn(canvas, "draw");
		var expected_date = new Date();
		var task = Task.init( { name: "Learn testing", date: expected_date } );
		view.user = "John";
		view.notify(task);
		expect(canvas.draw).toHaveBeenCalledWith("Task that is due on  " + expected_date +  " created!");

	If the handler relies on any instance property for it's operation, testing the handlers might require us to change/add properties to the controller instance that we setup during testing.

###Rendering

	Rendering a view is a job best done using the [Render Pattern](http://maccman.github.com/spine/#s-patterns-the-render-pattern).
	The rendering method will fetch all or part of a certain Model data, call a content genration method that will generate HTML from a static string or using a template engine 
	and then set that method output (the generated HTML) as the content of controller's root DOM element. 
	The fact that this pattern is implemented using small functions doing only one thing makes testing easier, one can make it easier by moving the data fetching code into a separate method that will be used in the rendering method.
	This can be seen with the following simple test case that tests the render method -
	
		 Controller under test:
     
    //= JavaScript
		var ContactsView = Spine.Controller.create({ 
			init: function() {
				Contact.bind( "refresh change", this.proxy(this.render) );
			},
			fetch: function() {
				return Contact.all();
			},
			template: function(items) { 
				return ($("#contactsTemplate").tmpl(items)); 
			} ,
			render:  function() { 
				this.el.html(this.template(this.fetch()); 
			} ,
		}
			
		The test:
	
	  //= JavaScript
		var fake_contacts =  { Contact.init( { first_name: "John" } ), Contact.init( { first_name: "Alex" } ) } ;
		ContactsView.extend( { template: jasmine.createSpy("templateSpy"), 
					       fetch: jasmine.createSpy("fetchStub").andReturn(fake_contacts) 
		});
		var view = ContactsView.init();
		view.render();
		expect(view.template).toHaveBeenCalledWith(fake_contacts);

	Testing the HTML generation method (the template method in this example) will require adding a HTML fixture that will contain the template it self. This can be done manually or by using the [Jasmine jQuery](https://github.com/velesin/jasmine-jquery) plugin setFixtures method - 
	
	  //= JavaScript
		setFixtures( '<script id="contactsTemplate" type="text/x-jquery-tmpl"> <li> <span> ${first_name} </span> </li> </script>' );

	And then testing that the template generates the correct HTML -
    
    //= JavaScript
		var view = ContactsView.init();
		var contacts =  { Contact.init( { first_name: "John" } ), Contact.init( { first_name: "Alex" } ) } ;
		var content = view.template(contacts); 
		expect(content).toEqual( "<li> <span> John </span> </li> <li> <span> Alex </span> </li>" );
	

###Template Helpers

	Helpers are simple functions to be used mostly by the template code in order to generate. This moves the logic into the controller or to helper code modules and doesn't couple it with the actual template.
	Setting the helper object as a property of the controller object will make it more accessible to testing  -

    //= JavaScript
		var ContactsView = Spine.Controller.create({
			helper: { format: function(name) { name.toUpperCase(); } }
		}

		var view = ContactsView.init();
		expect(view.helper.format('john')).toEqual('JOHN');

