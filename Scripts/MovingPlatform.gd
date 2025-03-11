extends AnimatableBody2D

@export var VAR_SPEED_X: float = 0.0
@export var speedMultiplier: float = 10.0
@export var speedLimit: float = 1000.0

func _physics_process(delta: float) -> void:
	var speed = clamp(VAR_SPEED_X * speedMultiplier, - speedLimit, speedLimit)
	move_and_collide(Vector2(speed * delta, 0))
	pass
