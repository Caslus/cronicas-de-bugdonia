extends SpellBlock
class_name FireballBlock

var fireballScene = preload("res://Scenes/Objects/Fireball.tscn")
var config = {}

func _init():
		shortName = "Fogo"
		name = "Runa de Bola de Fogo"
		description = "Esta runa lança uma bola de fogo."
		icon = preload("res://Assets/UI/Spells/Fireball.png")

func execute(context: Node) -> void:
		var fireball = fireballScene.instantiate()
		fireball.position = context.get_parent().position
		fireball.velocity = Vector2.RIGHT.rotated(context.get_parent().rotation) * fireball.speed

		var mouse_position = context.get_parent().get_global_mouse_position()
		var direction = (mouse_position - context.get_parent().position).normalized()
		fireball.velocity = direction * fireball.speed

		context.get_tree().root.add_child(fireball)
		pass
