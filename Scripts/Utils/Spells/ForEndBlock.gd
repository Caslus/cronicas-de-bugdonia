extends SpellBlock
class_name ForEndBlock

var config = {}

func _init():
		shortName = "ForEnd"
		name = "Runa de Fim de Loop"
		description = "Esta runa termina um loop."
		icon = preload("res://Assets/UI/Spells/ForEnd.png")

func execute(context: Node) -> void:
		pass