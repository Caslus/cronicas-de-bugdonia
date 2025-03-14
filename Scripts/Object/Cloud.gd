extends ParallaxLayer

@export var speed = 10.0
func _ready():
	pass

func _process(delta: float):
		motion_offset.x += speed * delta
