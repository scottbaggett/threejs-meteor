Package.describe({
    summary: "Backbone Marionette v1.0.4"
});

Package.on_use(function (api) {
    api.use('underscore', ['client', 'server']);
    api.add_files('lib/backbone-min.js','client')
    api.add_files('lib/backbone.marionette.min.js','client')
});
