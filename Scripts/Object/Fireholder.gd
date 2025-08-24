extends StaticBody2D

enum TYPE { AND, OR, XOR, NAND, NOR, XNOR}
var VAR_ACESA: bool
@export var ImageOff: CompressedTexture2D
@export var ImageOn: CompressedTexture2D
@export var torches: Array[Node2D] = []
@export var type: TYPE


@onready var sprite = get_node("Sprite")

func checkAnd() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") and B.get("VAR_ACESA"):
		return true
	return false

func checkOr() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") or B.get("VAR_ACESA"):
		return true
	return false

func checkXor() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") != B.get("VAR_ACESA"):
		return true
	return false

func checkNand() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") and B.get("VAR_ACESA"):
		return false
	return true

func checkNor() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") or B.get("VAR_ACESA"):
		return false
	return true

func checkXnor() -> bool:
	var A = torches[0]
	var B = torches[1]
	if A == null or B == null:
		return false
	if A.get("VAR_ACESA") == B.get("VAR_ACESA"):
		return true
	return false

func shouldLightUp() -> bool:
	if type == TYPE.AND: return checkAnd()
	if type == TYPE.OR: return checkOr()
	if type == TYPE.XOR: return checkXor()
	if type == TYPE.NAND: return checkNand()
	if type == TYPE.NOR: return checkNor()
	if type == TYPE.XNOR: return checkXnor()
	return false

func _process(_delta: float) -> void:
	VAR_ACESA = shouldLightUp()
	if VAR_ACESA:
		sprite.texture = ImageOn
		sprite.offset = Vector2(0, -153)
	else:
		sprite.texture = ImageOff
		sprite.offset = Vector2(0, 0)
