extends Resource
class_name SpellBlock

@export var shortName: String = "Runa"
@export var name: String = "Runa base"
@export var icon: Texture2D
@export_multiline var description: String = "Esta runa não faz nada."

func execute(context: Node) -> void:
    pass