class @ObjLoaderDemo
  init: ->
    @container = document.createElement("div")
    document.body.appendChild @container
    @camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 1, 2000)
    @camera.position.z = 100

    # @scene
    @scene = new THREE.Scene()
    ambient = new THREE.AmbientLight(0x101030)
    @scene.add ambient
    directionalLight = new THREE.DirectionalLight(0xffeedd)
    directionalLight.position.set 0, 0, 1
    @scene.add directionalLight

    # texture
    manager = new THREE.LoadingManager()
    manager.onProgress = (item, loaded, total) ->
      console.log item, loaded, total

    texture = new THREE.Texture()
    loader = new THREE.ImageLoader(manager)
    loader.load "textures/ash_uvgrid01.jpg", (image) ->
      texture.image = image
      texture.needsUpdate = true


    # model
    loader = new THREE.OBJLoader(manager)
    loader.load "obj/male02/male02.obj", (object) ->
      object.traverse (child) ->
        child.material.map = texture  if child instanceof THREE.Mesh

      object.position.y = -80
      @scene.add object


    #
    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize window.innerWidth, window.innerHeight
    @container.appendChild @renderer.domElement
    document.addEventListener "mousemove", onDocumentMouseMove, false

    #
    window.addEventListener "resize", onWindowResize, false
  onWindowResize: ->
    @windowHalfX = window.innerWidth / 2
    @windowHalfY = window.innerHeight / 2
    @camera.aspect = window.innerWidth / window.innerHeight
    @camera.updateProjectionMatrix()
    @renderer.setSize window.innerWidth, window.innerHeight
  onDocumentMouseMove: (event) ->
    @mouseX = (event.clientX - @windowHalfX) / 2
    @mouseY = (event.clientY - @windowHalfY) / 2

  #
  animate: ->
    requestAnimationFrame animate
    render()
  render: ->
    @camera.position.x += (@mouseX - @camera.position.x) * .05
    @camera.position.y += (-@mouseY - @camera.position.y) * .05
    @camera.lookAt @scene.position
    @renderer.render @scene, @camera

  constructor: ->
    @container = undefined
    @stats = undefined
    @camera = undefined
    @scene = undefined
    @renderer = undefined
    @mouseX = 0
    @mouseY = 0
    @windowHalfX = window.innerWidth / 2
    @windowHalfY = window.innerHeight / 2
    @init()
    # @animate()