extends StaticBody2D

@export var VAR_ACESA: bool = true
@export var ImageOff: CompressedTexture2D
@export var ImageOn: CompressedTexture2D

@export var editableVars: Array = []

@onready var sprite = get_node("Sprite")

func _process(delta: float) -> void:
	if VAR_ACESA:
		sprite.texture = ImageOn
		sprite.offset = Vector2(0, 0)
	else:
		sprite.texture = ImageOff
		sprite.offset = Vector2(7.2, 43)
