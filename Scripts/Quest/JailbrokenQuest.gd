extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {}
@export var npc: CharacterBody2D = null
@export var lock: StaticBody2D = null
@export var nextQuest: Node

func onUpdateQuestVariables():
	if questVariables.get("talked"):
		npc.set("startingDialog", "6")
	if questVariables.get("pickedWand"):
		npc.set("startingDialog", "7")
	if questVariables.get("talked2"):
		npc.set("startingDialog", "13")
		lock.set_meta("Interactable", true)
	if questVariables.get("finished"):
		npc.set("startingDialog", "14")
		QuestManager.currentQuest = nextQuest
	pass


func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
