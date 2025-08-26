extends Node2D

@export var quest: Node
@export var doorNumber: int = 1
@export var locked: bool = true
@onready var fog: ColorRect = self.get_parent().get_node("Fog")
var moving: bool = false

@onready var originalPosition: Vector2 = position

func open_door(signalDoor):
	print(signalDoor, doorNumber)
	if signalDoor != doorNumber: return
	moving = true
	var doorTween = create_tween()
	doorTween.set_ease(Tween.EaseType.EASE_IN_OUT)
	doorTween.tween_property(self, "position", originalPosition + Vector2(50, -550), 1)

	var fogTween = fog.create_tween()
	fogTween.set_ease(Tween.EaseType.EASE_IN_OUT)
	fogTween.tween_property(fog, "modulate", Color(1, 1, 1, 0), 1)

	await doorTween.finished
	moving = false

func close_door(signalDoor):
	if signalDoor != doorNumber: return
	moving = true
	var doorTween = create_tween()
	doorTween.set_ease(Tween.EaseType.EASE_IN_OUT)
	doorTween.tween_property(self, "position", originalPosition, 1)
	await doorTween.finished
	moving = false

func _ready():
	fog.visible = true
	quest.connect("openDoor", Callable(self, "open_door"))
	quest.connect("closeDoor", Callable(self, "close_door"))
