extends SpellBlock
class_name ForStartBlock

var config = {
	contagem = 1
}

func _init(_count: int = 1):
		shortName = "For"
		name = "Runa de Início de Loop"
		description = "Esta runa inicia um loop."
		config.contagem = _count

func execute(context: Node) -> void:
		pass
