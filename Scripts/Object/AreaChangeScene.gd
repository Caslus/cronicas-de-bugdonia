extends Area2D

@export var next_scene: String = "res://Scenes/Example.tscn"

func _on_body_entered(body):
	if body.name == "Player":
		TransitionCanvas.transition()
		await TransitionCanvas.on_transition_finished
		get_tree().change_scene_to_file(next_scene)