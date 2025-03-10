extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var camera: Camera2D = player.get_node("Camera2D")
@onready var originalCameraZoom: Vector2 = camera.zoom
@onready var originalCameraOffset: Vector2 = camera.offset

@export var zoomScale: float = 2.0
@export var zoomSpeed: float = 1.0

var interactable: Node2D = null
var interacting: bool = false

func set_interactable(node: Node2D):
	interactable = node

func cameraZoomIn():
	var tweenZoom = create_tween()
	tweenZoom.set_ease(Tween.EASE_IN_OUT)
	tweenZoom.tween_property(camera, "zoom", Vector2(zoomScale, zoomScale), zoomSpeed)

	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	var newCameraPosition = interactable.get_node("Sprite").get_global_position() - player.get_global_position()
	tweenPosition.tween_property(camera, "position", newCameraPosition, zoomSpeed)
	
	var tweenOffset = create_tween()
	tweenOffset.set_ease(Tween.EASE_IN_OUT)
	tweenOffset.tween_property(camera, "offset", Vector2(0, 0), zoomSpeed)


func cameraZoomOut():
	var tweenZoom = create_tween()
	tweenZoom.set_ease(Tween.EASE_IN_OUT)
	tweenZoom.tween_property(camera, "zoom", originalCameraZoom, zoomSpeed * 0.4)

	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	tweenPosition.tween_property(camera, "position", Vector2(0, 0), zoomSpeed * 0.4)
	
	var tweenOffset = create_tween()
	tweenOffset.set_ease(Tween.EASE_IN_OUT)
	tweenOffset.tween_property(camera, "offset", originalCameraOffset, zoomSpeed * 0.4)

func start_interaction():
	if (player == null or interactable == null):
		push_error("Player or interactable is null.")
		push_error("Player: " + str(player))
		push_error("Interactable: " + str(interactable))
		return

	interacting = true
	interactable.get_node("Interactable").set("enableExclamation", false)
	player.set("CAN_MOVE", false)
	cameraZoomIn()
	print(interactable.get("dialog")["1"]["text"])
	pass

func end_interaction():
	interacting = false
	cameraZoomOut()
	player.set("CAN_MOVE", true)
	interactable.get_node("Interactable").set("enableExclamation", true)
	interactable = null


func connectToInteractables():
	for interactableNode in get_tree().get_nodes_in_group("interactable"):
		interactableNode.connect("interactable", Callable(self, "_on_interactable"))

func _on_interactable(node: Node2D):
	set_interactable(node)

func _ready():
	connectToInteractables()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if interactable != null and not interacting:
			start_interaction()
		elif interacting:
			end_interaction()
	pass
