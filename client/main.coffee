
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

playSounds = false
Template.playSoundsButton.events
  'click': ->
    playSounds = if playSounds then false else true
    Session.set 'playSounds', playSounds
    log playSounds


Template.playSoundsButton.playSounds = -> Session.get 'playSounds'