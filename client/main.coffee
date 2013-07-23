Session.set('playSounds', true)

Meteor.startup ->
  require ['ThreeUI'], (ThreeUI) ->
    window.App      = new Backbone.Marionette.Application()
    App.addInitializer ->
      @ui = new ThreeUI()
      @ui.initialize()
      @ui.start()

    App.start()


Template.body.events
  'click #wrapper': ->
    App.ui.addRandomCube()



Template.playSoundsButton.events
  'click button': ->
    ps = Session.get('playSounds')
    ps = if ps == false then true else false
    Session.set 'playSounds', ps
    # log playSounds


Handlebars.registerHelper 'playSounds', ->
  Session.get 'playSounds'