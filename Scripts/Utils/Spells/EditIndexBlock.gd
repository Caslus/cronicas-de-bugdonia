extends SpellBlock
class_name EditIndexBlock

var editIndexSpellScene = preload("res://Scenes/Objects/EditIndexSpell.tscn")
var config = {
	indice = 0,
	valor = 0
}

func _init(_index, _value):
		shortName = "EditarIndice"
		name = "Runa de Edição de Índice"
		description = "Esta runa permite editar o índice de um vetor."
		icon = preload("res://Assets/UI/Spells/EditIndex.png")
		config.indice = _index
		config.valor = _value

func execute(context: Node) -> void:
		var projectile = editIndexSpellScene.instantiate()
		projectile.set_config(config.indice, config.valor)
		projectile.position = context.get_parent().position
		projectile.velocity = Vector2.RIGHT.rotated(context.get_parent().rotation) * projectile.speed

		var mouse_position = context.get_parent().get_global_mouse_position()
		var direction = (mouse_position - context.get_parent().position).normalized()
		projectile.velocity = direction * projectile.speed

		context.get_tree().root.add_child(projectile)
		pass
