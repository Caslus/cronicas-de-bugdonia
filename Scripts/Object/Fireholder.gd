extends StaticBody2D

enum TYPE { AND, OR, XOR, NAND, NOR, XNOR}
var VAR_ACESA: bool
@export var ImageOff: CompressedTexture2D
@export var ImageOn: CompressedTexture2D
@export var torches: Array[Node2D] = []
@export var type: TYPE

@onready var sprite = get_node("Sprite")

@onready var solver = get_parent().get_node_or_null("SolutionChecker")

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

func shouldLightUp() -> void:
	var should: bool = false
	if type == TYPE.AND: should = checkAnd()
	if type == TYPE.OR: should = checkOr()
	if type == TYPE.XOR: should = checkXor()
	if type == TYPE.NAND: should = checkNand()
	if type == TYPE.NOR: should = checkNor()
	if type == TYPE.XNOR: should = checkXnor()

	VAR_ACESA = should
	emit_signal("fireholderChanged")

func _process(_delta: float) -> void:
	if VAR_ACESA:
		sprite.texture = ImageOn
		sprite.offset = Vector2(0, -153)
	else:
		sprite.texture = ImageOff
		sprite.offset = Vector2(0, 0)

func _ready() -> void:
	SelectedManager.connect("selected_edited", Callable(self, "shouldLightUp"))

signal fireholderChanged()
