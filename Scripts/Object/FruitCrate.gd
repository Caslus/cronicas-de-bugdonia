extends StaticBody2D

@export var VAR_ROTULO: String = ''
@export var editableVars: Array = ["VAR_ROTULO"]

@onready var sprite = get_node("Sprite")
@onready var originalTexture = sprite.texture
@export var spriteUnknown: CompressedTexture2D
@export var spriteBanana: CompressedTexture2D
@export var spriteOrange: CompressedTexture2D
@export var spritePineapple: CompressedTexture2D
@export var spriteWatermelon: CompressedTexture2D

func _process(delta: float) -> void:
	if VAR_ROTULO != '':
		if VAR_ROTULO.to_lower() == "banana":
			sprite.texture = spriteBanana
		elif VAR_ROTULO.to_lower() == "laranja":
			sprite.texture = spriteOrange
		elif VAR_ROTULO.to_lower() == "abacaxi":
			sprite.texture = spritePineapple
		elif VAR_ROTULO.to_lower() == "melancia":
			sprite.texture = spriteWatermelon
		else:
			sprite.texture = spriteUnknown
	else:
		sprite.texture = originalTexture
