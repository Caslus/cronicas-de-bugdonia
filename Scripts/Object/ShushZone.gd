extends Area2D

@export var guardWokeFace: CompressedTexture2D

@onready var guard = get_parent()
@onready var player = get_tree().get_nodes_in_group("player")[0]


func _on_body_entered(body):
	if body.name == "Player" and body.get("VAR_VOLUME_PASSOS") > 2:
		guard.get_node("Sprite").get_node("head").texture = guardWokeFace
		guard.set("startingDialog", "caught")
		player.get_node("InteractionManager").interactable = guard
		player.get_node("InteractionManager").interacting = false
		player.get_node("InteractionManager").start_interaction()


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
