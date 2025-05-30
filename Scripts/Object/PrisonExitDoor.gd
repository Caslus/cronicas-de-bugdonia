extends Area2D

@onready var guard = get_parent()
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
@export var nextQuest: Node

func _on_body_entered(body):
	if body.name == "Player":
		QuestManager.currentQuest = nextQuest
		QuestManager.toggleQuestVar("escaped")
		TransitionCanvas.transition()
		await TransitionCanvas.on_transition_finished
		player.translate(Vector2(2000, 0))
		player.set("RESPAWN_POINT", Vector2(8691.498, -125.0015))
		


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
