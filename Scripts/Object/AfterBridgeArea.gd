extends Area2D

@onready var guard = get_parent()
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

func _on_body_entered(body):
	if body.name == "Player":
		QuestManager.toggleQuestVar("passed")
		player.set("RESPAWN_POINT", Vector2(14500.0, -125.0015))


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
