extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {}

@export var cauldron: Node2D
@export var ogre: Node2D
@export var ogreBarrier: StaticBody2D

@export var cauldronGreen: CompressedTexture2D
@export var cauldronBubbleGreen: CompressedTexture2D

@export var nextQuest: Node

@export var tipUI: PackedScene
@export_multiline var tipText: String

var challengeTimer: Timer = null
@export var tipWaitTime: float = 90.0

func startChallenges():
	if challengeTimer != null: return
	challengeTimer = Timer.new()
	challengeTimer.wait_time = tipWaitTime
	challengeTimer.one_shot = true
	challengeTimer.connect("timeout", Callable(self, "onChallengeTimeout"))
	add_child(challengeTimer)
	challengeTimer.start()

func onChallengeTimeout():
	var tipInstance = tipUI.instantiate()
	tipInstance.setTipText(tipText)
	add_child(tipInstance)

func onUpdateQuestVariables():
	if questVariables.get("talked") and !questVariables.get("cooked"):
		ogre.set("startingDialog", "6")
		cauldron.set_meta("Interactable", true)
		startChallenges()
	if questVariables.get("cooked"):
		ogre.set("startingDialog", "8")
	if questVariables.get("finished"):
		ogre.set("startingDialog", "11")
		var barrier: CollisionShape2D = ogreBarrier.get_node("Collision")
		barrier.disabled = true
		if challengeTimer != null:
			challengeTimer.queue_free()
			challengeTimer = null
		QuestManager.setCurrentQuest(nextQuest)
	pass


func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))

func _process(_delta: float) -> void:
	var eggOk = cauldron.get("VAR_OVO_DE_DRAGAO") == 3
	var droolOk = cauldron.get("VAR_BABA_DE_TROLL") == 1.5
	var juiceOk = cauldron.get("VAR_SUCO_DE_COGUMELO_LUNAR") == 0.5
	var bonesOk = cauldron.get("VAR_CALDO_DE_OSSOS_QUEBRADOS") == 1.0
	var allOk = eggOk and droolOk and juiceOk and bonesOk
	
	if(allOk and !questVariables.get("cooked")):
		cauldron.set_meta("Interactable", false)
		var sprite: Sprite2D = cauldron.get_node("Sprite")
		sprite.texture = cauldronGreen
		var particleEmitter: CPUParticles2D = sprite.get_node("Particles")
		particleEmitter.texture = cauldronBubbleGreen
		SelectedManager.set_selected(null)
		questVariables.set("cooked", true)
		onUpdateQuestVariables()
