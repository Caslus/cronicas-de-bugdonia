class_name CastShadow extends Node2D

@onready var raycast: RayCast2D = get_node("RayCast2D")
@onready var pointlight: PointLight2D = get_node("PointLight2D")

var rayCollisionPoint: float = 0.0

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding():
		rayCollisionPoint = raycast.get_collision_point().y
	else:
		rayCollisionPoint = raycast.global_position.y + raycast.target_position.y

	pointlight.global_position.y = rayCollisionPoint
	pointlight.energy = max(1.0 - pointlight.position.y / raycast.target_position.y, 0.0)
