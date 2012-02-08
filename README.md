Prototype YUI Loader Stand Alone
================================

This repo contains a little build script to create a stand alone version
of the latest YUI 3.5.0pr2 Loader.

It includes:

    yui-core
    get
    loader-base

Currently it's 225k raw, 43k minimized and 16K minned and gzipped.

This can easily be worked on once I modularize the YUI core more so it doesn't
contain things that are not needed all the time.

Example here:
http://dl.dropbox.com/u/5669457/loader-alone/test/index.html

**Notice that YUI is not loaded on the page, it's there but wrapped up in an anonymous function.**

Usage
-----

Everything you need to use Loader is already on this repo, the `build` directory contains
a loader.js and loader-min.js

```javascript
var loader = new YUILoader({
    root: '',
    base: '',
    groups: {
        local: {
            modules: {
                foo: {
                    type: 'js',
                    path: 'foo/foo.js',
                    requires: [ 'bar', 'baz' ]
                },
                baz: 'path/to/baz.js',
                bar: 'bar.js',
                somecss: 'my/css/files.css'
            }
        }
    },
    require: [ 'foo', 'somecss' ]
});

loader.load(function(e) {
    log('All items have been loaded..', e);
});
```


Concept
-------

The concept here is pretty simple, it concats `yui-core`, `get` &amp; `loader-base` into a single file.
Then it wraps that code with something like this:

```javascript
(function() {
    var YUI;
    var exports = {};

    //Concatted Source here

    YUI.Env.core.push('loader-base');

    var Y = YUI();

    window.YUILoader = Y.Loader;

    Y.Loader.expose = Y.Loader.prototype.expose = function(cb) {
        YUI.Env.core = [].concat(YUI.Env.core, ['loader-yui3', 'features', 'intl-base']);
        if (!window.YUI) { //Have to globally expose now for YUI.add calls.
            window.YUI = YUI;
        }
        Y.use('loader-yui3', 'features', 'intl-base', function() {
            delete YUI.Env._loader;
            delete YUI.Env._renderedMods;
            
            cb(window.YUI);
        });
    }


}());
```

This wrapping code is boilerplate for forcing YUI to attach itself to the `exports` object.
Then augment the core to autoload the `loader-base` module, then expose a global `YUILoader` var.
Then it adds a `expose` method as a static method and into Loader's prototype.
This method is used to expose the exported `YUI` module and fetch the other parts of `YUI` needed
to make it fully functional (features, loader metadata, intl-base).

Exposing YUI
------------

This prototype scopes the global `YUI` onto a local `exports` object, holding it in a private scope
so that it only exposes `Loader` globally. Maybe you want to load simple modules up front, but later
on in your code you need other things from the library. That's where `expose` comes in. Simply
call `YUILoader.expose(cb)` with a callback and `Loader` will fetch the parts of YUI it needs to
complete the transaction and fire your callback when all the dependencies are complete.


```javascript
YUILoader.expose(function() {
    YUI().use('node', fn);
});
```
