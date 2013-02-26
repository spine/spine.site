<%- title 'Model Relationships' %>

Spine provides a number of ways of handling relationships between models, such as *has many* and *belongs to* relationships.

However, ideally you should try and abstract relationships out of your models on the client-side if they're not absolutely necessary. Checkout *A note on API design* in the [Ajax guide](<%= docs_path("ajax") %>) for more information. Anyway, if relationships are necessary, here's how to use them. 

##Usage

Spine's relationship logic is available in a separate module to the rest of the library, [relation.js](https://raw.github.com/spine/spine/master/lib/relation.js). You'll need to include that in your application before continuing. 

##Has many associations

You can set up *has many* associations by using `hasMany(name, path)`. For example:

    //= CoffeeScript
    class Photo extends Spine.Model
      @configure 'Photo'
      
      @belongsTo 'album', 'Album'
    
    class Album extends Spine.Model
      @configure 'Album', 'name'
      
      @hasMany 'photos', 'models/photo'
    
    //= JavaScript
    var Photo = Spine.Model.sub();
    Photo.configure('Photo');
    Photo.belongsTo('album', 'Album');
    
    var Album = Spine.Model.sub();
    Album.configure('Album', 'name);
    
    Album.hasMany('photos', 'Photo');
    
The `hasMany()` function takes the name of the association, the path to the associated model, and an optional foreign key. 

If you're using [CommonJS modules](<%= docs_path("commonjs") %>), than use the path to the model as you'd `require()` it. In the example above, this is `models/photo`. Otherwise, pass a string indicating the global available variable referring to the associated model, in this case `Photo`.

Usage is fairly straightforward. The association gives you a few functions, such as `all()`, `find()` and `create()`:
    
    //= CoffeeScript  
    album = Album.create()
    
    # Fetch all album's photos
    album.photos().all()
    
    album.photos().create(
      name: "First photo"
    )
    
    album.photos().find( Photo.first().id )

##Belongs to associations

A *belongs to* association is very similar, using the `belongsTo(name, path)` function.

    //= CoffeeScript
    class Album extends Spine.Model
      @configure 'Album', 'name'
    
    class Photo extends Spine.Model
      @configure 'Photo'
  
      @belongsTo 'album', 'Album'

    //= JavaScript
    var Album = Spine.Model.sub();
    Album.configure('Album', 'name);

    var Photo = Spine.Model.sub();
    Photo.configure('Photo');
    Photo.belongsTo('album', 'Album');
    
Like `hasMany()`, the `belongsTo()` function gives you an relationship property on record instances, in this case called `album`.

    //= CoffeeScript
    album = Album.create({name: "First Album"})
    photo = Photo.create({album: album})
    
    assertEqual( photo.album(), album )
    assertEqual( photo.album_id, album.id )
    
