extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {}

@export var merchant: Node2D
@export var merchantBarrier: StaticBody2D
@export var cratesList: Node2D
@onready var crates: Array[Node] = cratesList.get_children()

@export var happyFace: CompressedTexture2D

var requiredFruits = ["banana", "laranja", "abacaxi", "melancia"]

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
	if questVariables.get("talked"):
		merchant.set("startingDialog", "7")
		for crate: StaticBody2D in crates:
			crate.set_meta("Interactable", true)
		startChallenges()
	if questVariables.get("fruitsOk"):
		SelectedManager.set_selected(null)
		merchant.set("startingDialog", "8")
		merchant.get_node("Sprite").get_node("head").texture = happyFace
		for crate: StaticBody2D in crates:
			crate.set_meta("Interactable", false)
		if challengeTimer != null:
			challengeTimer.queue_free()
			challengeTimer = null
	if questVariables.get("finished"):
		merchant.set("startingDialog", "9")
		var barrier: CollisionShape2D = merchantBarrier.get_node("Collision")
		barrier.disabled = true
	pass

func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))

func _process(_delta: float) -> void:
	if questVariables.get("talked") and not questVariables.get("fruitsOk"):
		var fruitsFound = []
		for crate in crates:
			var fruitVar: String = crate.get("VAR_ROTULO")
			fruitVar = fruitVar.to_lower()
			if fruitVar in requiredFruits and fruitVar not in fruitsFound:
					fruitsFound.append(fruitVar)
		if fruitsFound.size() == 4:
			QuestManager.toggleQuestVar("fruitsOk")
