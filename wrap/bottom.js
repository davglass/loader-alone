
YUI.Env.core.push('loader-base');
YUI.Env.core.push('yui-log');

YUI.GlobalConfig = {
    modules: {
        'loader-yui3': {
            requires: [ 'loader-base' ]
        },
        'features': {
            requires: [ 'loader-base' ]
        },
        'intl-base': {
            requires: [ 'loader-base' ]
        }
    }
};

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
