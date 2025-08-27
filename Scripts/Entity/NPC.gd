extends CharacterBody2D

@export var dialogFile: String = "res://Dialog/NPC_Test.json"
var dialog: Dictionary = {}
@export var startingDialog: String = "1"
@export var quest: Node = null

@export var turnsToPlayer: bool = true
var moving: bool = false

# texture for sprites
@export var head: CompressedTexture2D = null
@export var torso: CompressedTexture2D = null
@export var arm: CompressedTexture2D = null
@export var leg: CompressedTexture2D = null

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

@onready var animTree: AnimationTree = get_node("AnimationTree")


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

func move_to(npcName: String, pos: Vector2):
	if get_meta("objectName") != npcName: return
	moving = true
	turnsToPlayer = false
	disable_interaction()
	var torsoNode = get_node("Sprite")
	if (pos.x > position.x):
		torsoNode.scale = Vector2(-1, 1)
	else:
		torsoNode.scale = Vector2(1, 1)
	var moveTween1 = create_tween()
	moveTween1.set_ease(Tween.EaseType.EASE_IN_OUT)
	moveTween1.tween_property(self, "position", position + Vector2(0, 100), 0.5)
	await moveTween1.finished
	var moveTween2 = create_tween()
	moveTween2.set_ease(Tween.EaseType.EASE_IN_OUT)
	moveTween2.tween_property(self, "position", Vector2(pos.x, position.y), 4.0)
	await moveTween2.finished
	var moveTween3 = create_tween()
	moveTween3.set_ease(Tween.EaseType.EASE_IN_OUT)
	moveTween3.tween_property(self, "position", pos, 0.5)
	await moveTween3.finished
	moving = false
	turnsToPlayer = true
	enable_interaction()

func disable_interaction():
	var interactable = get_node("Interactable")
	interactable.enableExclamation = false
	interactable.enableInteraction = false

func enable_interaction():
	var interactable = get_node("Interactable")
	interactable.enableExclamation = true
	interactable.enableInteraction = true

func _ready():
	load_dialog()
	load_textures()
	QuestManager.connect("moveNpc", Callable(self, "move_to"))

func _process(_delta):
	var torsoNode = get_node("Sprite")
	if turnsToPlayer:
		if player.global_position.x > global_position.x:
			torsoNode.scale = Vector2(-1, 1)
		else:
			torsoNode.scale = Vector2(1, 1)

	animTree.set("parameters/conditions/walk", moving)
	animTree.set("parameters/conditions/idle", not moving)
