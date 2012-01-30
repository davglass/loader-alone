

YUI.Env.core.push('loader-base');

var Y = YUI();

window.YUILoader = Y.Loader;

Y.Loader.prototype.load = function(cb) {
    var self = this,
        out = self.resolve(true);
    
    self.data = out;
        
    self.onEnd = function() {
        cb.apply(self.context || window, arguments);
    }

    self.insert();
}

}());
