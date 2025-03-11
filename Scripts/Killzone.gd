extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.position = Vector2(-270, -270)


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
