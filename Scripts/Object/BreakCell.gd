extends Area2D

@export var brokenCell: CompressedTexture2D
var breakSound = preload("res://Assets/Audio/StoneImpact.wav")

@onready var cell = get_parent()
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var audioStreamPlayer = player.get_node("AudioStreamPlayer2D")

var broken: bool = false


func _on_body_entered(body):
	if body.name == "Player" and !broken:
		broken = true
		cell.texture = brokenCell
		audioStreamPlayer.stream = breakSound
		audioStreamPlayer.play()


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
