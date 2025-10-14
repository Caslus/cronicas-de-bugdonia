extends SpellBlock
class_name ExplosionBlock

var explosionScene = preload("res://Scenes/Objects/Explosion.tscn")
var config = {
	"linha": 0,
	"coluna": 0
}

func _init(_coluna, _linha):
		shortName = "explosao"
		name = "Runa de Explosão"
		description = "Esta runa convoca uma explosão de fogo."
		icon = preload("res://Assets/UI/Spells/Explosion.png")
		config["coluna"] = _coluna
		config["linha"] = _linha

func execute(context: Node) -> void:
		var helper: Node = context.get_node("SpellHelper")
		if !helper: return
		helper.spawn_explosion(config["coluna"], config["linha"])
		pass
