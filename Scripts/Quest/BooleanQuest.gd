extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {
	"initialTalk": false
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

func onUpdateQuestVariables():
	if questVariables.get("initialTalk"):
		# npc.set("startingDialog", "5")
		emit_signal("openDoor", 1)
		print("Opening door:", 1)
		QuestManager.moveNpcTo(npc.get_meta("objectName"), Vector2(2432, -342))
	# if questVariables.get("pickedWand"):
	# 	npc.set("startingDialog", "7")
	# if questVariables.get("talked2"):
	# 	npc.set("startingDialog", "13")
	# if questVariables.get("finished"):
	# 	npc.set("startingDialog", "14")
	# 	QuestManager.setCurrentQuest(nextQuest)
	pass


func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))

signal openDoor(doorNumber)
signal closeDoor(doorNumber)
