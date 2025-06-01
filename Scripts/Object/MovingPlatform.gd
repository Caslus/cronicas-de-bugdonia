extends AnimatableBody2D

@export var VAR_VELOCIDADE_HORIZONTAL: int = 0
@export var speedMultiplier: float = 10.0
@export var speedLimit: float = 1000.0
@export var editableVars: Array = ["VAR_VELOCIDADE_HORIZONTAL"]

func _physics_process(delta: float) -> void:
	var speed = clamp(VAR_VELOCIDADE_HORIZONTAL * speedMultiplier, - speedLimit, speedLimit)
	move_and_collide(Vector2(speed * delta, 0))
	pass
