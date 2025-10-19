extends Node

@export var questName: String = '["V", "e", "t", "o", "r", "e", "s"]'
@export var questDescription: String = "Manipule um vetor para abrir o portão do castelo."
@export var questVariables: Dictionary = {
	"teachEditIndex": false,
	"teachLightning": false,
	"talked": false,
	"opened": false
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

@export var spellManager: Node = null
@export var spellEditor: Control = null

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
	if questVariables.get("teachEditIndex"):
		spellManager.allowedToCast = true
		spellEditor.allowedToUseEditor = true
		spellManager.learn_rune("editarindice")
	if questVariables.get("teachLightning"):
		spellManager.learn_rune("raio")
	if questVariables.get("talked"):
		npc.set("startingDialog", "10")
		spellManager.learn_rune("tempo")
		startChallenges()
	if questVariables.get("opened"):
		npc.set("startingDialog", "12")
		if challengeTimer != null:
			challengeTimer.queue_free()
			challengeTimer = null

func _ready():
	QuestManager.currentQuest = self
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
