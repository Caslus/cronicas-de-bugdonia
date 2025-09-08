extends SpellBlock
class_name ForStartBlock

var config = {
	contagem = 1
}

func _init(_count: int = 1):
		shortName = "For"
		name = "Runa de Início de Loop (For)"
		description = "Esta runa inicia um loop (For)."
		icon = preload("res://Assets/UI/Spells/ForStart.png")
		config.contagem = _count

func execute(context: Node) -> void:
		pass
