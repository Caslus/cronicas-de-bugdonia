extends Sprite2D

@export var speed = 10.0
@export var direction: bool = false
@export var boundary: float = 0.0
@export var origin: float = 0.0

func _ready():
	pass

func _process(delta: float):
	position.x += speed * delta * -1.0
	if direction and position.x > boundary:
		position.x = origin
	elif not direction and position.x < boundary:
		position.x = origin