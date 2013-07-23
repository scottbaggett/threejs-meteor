define 'ThreeUI', [], () ->

  class ThreeUI
    camera:         null
    scene:          null
    rendered:       null
    geometry:       null
    width:          0
    height:         0

    initialize: ->
      @initContainer()
      @initScene()
      @initCamera()
      @initRenderer()
      @bindResize()
      @initControls()
      @initStats()
      @addLights()

    addRandomCube: =>
      rnd = 20 + Math.random() * 40
      mat = new THREE.MeshPhongMaterial color: 0xfcef00
      geom = new THREE.CubeGeometry rnd, rnd, rnd
      mesh = new THREE.Mesh geom, mat
      mesh.position.x = ( Math.random() - 0.15 ) * 500
      mesh.position.y = ( Math.random() - 0.15 ) * 500
      mesh.position.z = ( Math.random() - 0.15 ) * 500
      mesh.castShadow = true
      mesh.randomPower = 1 + (100  * Math.random())
      mesh.receiveShadow = false

      sound = _.shuffle(['one','two','three','four'])[0]
      s = new buzz.sound("/sounds/#{sound}.ogg");
      s.setVolume(30)
      playSounds = Session.get('playSounds')
      log 'playSounds', playSounds
      s.play() if playSounds


      ['x', 'y', 'z'].forEach (axis) ->
        mesh.rotation[axis] = Math.random() * 360

      @addToScene mesh

      # animate the square in from a random point in space.
      tween = new TWEEN.Tween(
          x: 4000 * Math.random()
          y: 4000 * Math.random()
          z: 4000 * Math.random()
          rotationX: mesh.rotation.x
        )
        .to({rotationX: 0, x: mesh.position.x, y: mesh.position.y, z: mesh.position.z}, 500)
        .easing(TWEEN.Easing.Exponential.Out)
        .onUpdate ->
          mesh.rotation.x = this.rotationX
          mesh.position.x = this.x
          mesh.position.y = this.y
          mesh.position.z = this.z
      tween.start()

    addLights: =>
      light = new THREE.DirectionalLight( 0xffffff )
      light.position.set( 12, 5, 1 )
      light.castShadow = true
      light.shadowDarkness = 0.5
      light.shadowCameraNear = 0.01
      @scene.add light

    initContainer: ->
      @container  = document.getElementById( 'container' )

    bindResize: ->
      window.addEventListener  'resize', @onWindowResize, false

    onWindowResize: =>
      @camera.aspect = window.innerWidth / window.innerHeight
      @camera.updateProjectionMatrix()
      @renderer.setSize window.innerWidth, window.innerHeight
      @render()

    initScene: ->
      @scene = new THREE.Scene()

    initCamera: ->
      @camera = new THREE.PerspectiveCamera 50, window.innerWidth / window.innerHeight, 1, 4000
      @camera.position.set 456, 350, 400

    initRenderer: ->
      @renderer = new THREE.WebGLRenderer antialias: true
      @renderer.setSize window.innerWidth, window.innerHeight
      @renderer.shadowMapEnabled = true
      @renderer.shadowMapSoft = true

    initControls: ->
      @controls  = new THREE.OrbitControls @camera
      @controls.addEventListener 'change', @render

    initStats: () ->
      @stats = new Stats()
      @stats.domElement.style.position = "absolute"
      @stats.domElement.style.top = "0px"
      @stats.domElement.style.zIndex = 100
      @container.appendChild @stats.domElement
      document.getElementById('wrapper').appendChild @renderer.domElement

    start: ->
      @animate()

    render: =>
      @renderer.render @scene, @camera

    # add a mesh object to a scene
    addToScene: (mesh) =>
      @scene.add mesh

    animate: =>
      requestAnimationFrame @animate
      @stats.update()
      window.TWEEN?.update()
      @controls?.update()
      @render()