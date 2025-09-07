extends Node2D

@export var speed: float = 400.0
@export var lifetime: float = 2.0
var velocity: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func _process(delta):
		position += velocity * delta
		time_alive += delta
		if time_alive > lifetime:
				queue_free()
