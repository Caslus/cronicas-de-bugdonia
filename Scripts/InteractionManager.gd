extends Node

@onready var player: CharacterBody2D = get_parent()
@onready var dialogManager: Node = get_node("../DialogManager")
@onready var camera: Camera2D = player.get_node("Camera2D")
@onready var originalCameraZoom: Vector2 = camera.zoom
@onready var originalCameraOffset: Vector2 = camera.offset
@onready var itemInteractionPanel: Panel = $UI/ItemInteractionPanel
@export var zoomScale: float = 2.0
@export var zoomSpeed: float = 0.6

var interactable: Node2D = null
var interacting: bool = false

signal start_dialog(npc, dialog)
signal pickup_item(item)

func set_interactable(node: Node2D):
	interactable = node

func interactWithItem():
	var item = interactable
	var itemName = item.get_meta("objectName")
	var itemDescription = item.get_meta("objectDescription")
	var itemNameLabel: Label = itemInteractionPanel.get_node("MarginContainer/ItemMessageBox/ItemName")
	var itemDescriptionLabel: RichTextLabel = itemInteractionPanel.get_node("MarginContainer/ItemMessageBox/ItemDescription")
	var itemCloseButton: Button = itemInteractionPanel.get_node("CloseButton")
	itemNameLabel.text = itemName
	itemDescriptionLabel.text = itemDescription
	itemCloseButton.connect("pressed", Callable(self, "end_interaction"))
	itemInteractionPanel.visible = true

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
	tweenZoom.tween_property(camera, "zoom", originalCameraZoom, zoomSpeed)

	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	tweenPosition.tween_property(camera, "position", Vector2(0, 0), zoomSpeed)
	
	var tweenOffset = create_tween()
	tweenOffset.set_ease(Tween.EASE_IN_OUT)
	tweenOffset.tween_property(camera, "offset", originalCameraOffset, zoomSpeed)

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
	if interactable.get_meta("InteractionType") == "Dialog":
		emit_signal("start_dialog", interactable, interactable.get("dialog"))
	if interactable.get_meta("InteractionType") == "Item":
		interactWithItem()
	pass

func end_interaction():
	if interactable.get_meta("InteractionType") == "Item":
		itemInteractionPanel.visible = false
		emit_signal("pickup_item", interactable)

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
	dialogManager.connect("end_dialog", Callable(self, "end_interaction"))
	connectToInteractables()
	pass

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if interactable != null and not interacting:
			start_interaction()
	pass
