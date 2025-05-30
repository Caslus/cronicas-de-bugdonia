extends Button

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

func _on_pressed() -> void:
	print(player.transform)
