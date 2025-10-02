extends SpellBlock
class_name LightningBlock

var lightningScene = preload("res://Scenes/Objects/Lightning.tscn")
var config = {}

func _init():
		shortName = "Raio"
		name = "Runa de Raio"
		description = "Esta runa convoca um raio de eletricidade."
		icon = preload("res://Assets/UI/Spells/Lightning.png")

func execute(context: Node) -> void:
		var lightning = lightningScene.instantiate()
		var mouse_position = context.get_parent().get_global_mouse_position()
		var start_position = Vector2(mouse_position.x, -1000)
		var raycast = RayCast2D.new()
		var collision: Node = null
		raycast.position = start_position
		raycast.target_position = Vector2(0, 2000)
		raycast.enabled = true
		context.get_tree().root.add_child(raycast)
		raycast.force_raycast_update()
		if raycast.is_colliding():
			lightning.position = raycast.get_collision_point()
			collision = raycast.get_collider()
			if collision.has_method("electrocute"):
				collision.electrocute()
		else:
			lightning.position = Vector2(mouse_position.x, 1000)
		raycast.queue_free()
		context.get_tree().root.add_child(lightning)
		pass
