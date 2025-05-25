extends CharacterBody2D

@export var dialogFile: String = "res://Dialog/NPC_Test.json"
var dialog: Dictionary = {}
@export var startingDialog: String = "1"
@export var quest: Node = null

@export var turnsToPlayer: bool = true

# texture for sprites
@export var head: CompressedTexture2D = null
@export var torso: CompressedTexture2D = null
@export var arm: CompressedTexture2D = null
@export var leg: CompressedTexture2D = null

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]


func load_dialog():
	var file = FileAccess.open(dialogFile, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	for i in range(content.size()):
		dialog[content[i]["id"]] = content[i]
	file.close()

func load_textures():
	var torsoNode = get_node("Sprite")
	var headNode = torsoNode.get_node("head")
	var l_arm = torsoNode.get_node("l_arm")
	var l_leg = torsoNode.get_node("l_leg")
	var r_arm = torsoNode.get_node("r_arm")
	var r_leg = torsoNode.get_node("r_leg")

	torsoNode.texture = torso
	headNode.texture = head
	l_arm.texture = arm
	l_leg.texture = leg
	r_arm.texture = arm
	r_leg.texture = leg


func _ready():
	load_dialog()
	load_textures()
	pass

func _process(_delta):
	var torsoNode = get_node("Sprite")
	if player.global_position.x > global_position.x and turnsToPlayer:
		torsoNode.scale = Vector2(-1, 1)
	else:
		torsoNode.scale = Vector2(1, 1)
	pass
