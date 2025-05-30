extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {}
@export var nextQuest: Node
@export var npc: CharacterBody2D = null
@export var prisoner: CharacterBody2D
@export var guardSleepingFace: CompressedTexture2D

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var audioStreamPlayer = player.get_node("AudioStreamPlayer2D")
var angelChoir = preload("res://Assets/Audio/AngelChoir.wav")

func respawn_player(player):
	var respawnNode: Node2D = player.get_node("Respawn")
	var godHand: Sprite2D = respawnNode.get_node("GodHand")
	godHand.position = Vector2(-123.0, -2000.0)
	player.CAN_MOVE = false
	player.BEING_RESPAWNED = true
	var playerCollision: CollisionShape2D = player.get_node("CollisionShape2D")
	#playerCollision.disabled = true
	
	audioStreamPlayer.stream = angelChoir
	audioStreamPlayer.play()

	godHand.visible = true
	var godRays: Sprite2D = respawnNode.get_node("Godrays")
	godRays.visible = true
	var tweenGodrays = create_tween()
	tweenGodrays.set_ease(Tween.EASE_IN_OUT)
	tweenGodrays.tween_property(godRays.material, "shader_parameter/edge_fade", 0.111, 3.0)

	var tweenGodHandDown = create_tween()
	tweenGodHandDown.set_ease(Tween.EASE_IN_OUT)
	tweenGodHandDown.tween_property(godHand, "position", Vector2(godHand.position.x, -445.0), 5.0)
	await tweenGodHandDown.finished

	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	tweenPosition.tween_property(player, "position", Vector2(player.position.x, -600.0), 2.0)
	tweenPosition.tween_property(player, "position", Vector2(player.RESPAWN_POINT.x, -600.0), 2.0)
	tweenPosition.tween_property(player, "position", player.RESPAWN_POINT, 2.0)
	await tweenPosition.finished

	player.BEING_RESPAWNED = false
	#playerCollision.disabled = false
	
	var tweenHandPosition = create_tween()
	tweenHandPosition.set_ease(Tween.EASE_IN_OUT)
	tweenHandPosition.tween_property(godHand, "position", Vector2(godHand.position.x, -2000.0), 0.5)
	await tweenHandPosition.finished

	godHand.visible = false
	var tweenGodrays2 = create_tween()
	tweenGodrays2.set_ease(Tween.EASE_IN_OUT)
	tweenGodrays2.tween_property(godRays.material, "shader_parameter/edge_fade", 1.0, 0.25)
	await tweenGodrays2.finished

	godRays.visible = false
	player.CAN_MOVE = true
	npc.get_node("Sprite").get_node("head").texture = guardSleepingFace


func onUpdateQuestVariables():
	if questVariables.get("read"):
		player.get("editableVars").append("VAR_VOLUME_PASSOS")
	if questVariables.get("talked"):
		npc.set("startingDialog", "2")
	if questVariables.get("caught"):
		respawn_player(player)
		questVariables.set("caught", false)
		npc.set("startingDialog", "1")
		prisoner.set("startingDialog", "caught")
	if questVariables.get("escaped"):
		QuestManager.currentQuest = nextQuest
	pass


func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
