extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {
	"initialTalk": false,

	"taughtAnd": false,
	"okAnd": false,

	"taughtOr": false,
	"okOr": false,

	"taughtXor": false,
	"okXor": false,

	"taughtNand": false,
	"okNand": false,

	"taughtNor": false,
	"okNor": false,

	"taughtXnor": false,
	"okXnor": false,

	"taughtAndOr": false,
	"okAndOr": false,

	"okChallenge1": false
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

func moveNpc(pos: Vector2, speed: float = 4.0) -> void:
	if npc.position.x > pos.x: return
	if npc.position != pos and not npc.moving:
		QuestManager.moveNpcTo(npc.get_meta("objectName"), pos, speed)

func onUpdateQuestVariables():
	if questVariables.get("initialTalk"):
		npc.set("startingDialog", "5")
		emit_signal("openDoor", 1)
		moveNpc(Vector2(2432, -342))
	
	if questVariables.get("taughtAnd"):
		emit_signal("enableTorches", 2)
	if questVariables.get("okAnd"):
		npc.set("startingDialog", "8")
		moveNpc(Vector2(4045, -342))

	if questVariables.get("taughtOr"):
		emit_signal("enableTorches", 3)
	if questVariables.get("okOr"):
		npc.set("startingDialog", "11")
		moveNpc(Vector2(5682, -342))

	if questVariables.get("taughtXor"):
		emit_signal("enableTorches", 4)
	if questVariables.get("okXor"):
		npc.set("startingDialog", "14")
		moveNpc(Vector2(7266, -342))
	
	if questVariables.get("taughtNand"):
		emit_signal("enableTorches", 5)
	if questVariables.get("okNand"):
		npc.set("startingDialog", "17")
		moveNpc(Vector2(8805, -342))

	if questVariables.get("taughtNor"):
		emit_signal("enableTorches", 6)
	if questVariables.get("okNor"):
		npc.set("startingDialog", "19")
		moveNpc(Vector2(10482, -342))

	if questVariables.get("taughtXnor"):
		emit_signal("enableTorches", 7)
	if questVariables.get("okXnor"):
		npc.set("startingDialog", "20")
		moveNpc(Vector2(11134, -342), 1.0)
	
	if questVariables.get("taughtAndOr"):
		emit_signal("enableTorches", 8)
	if questVariables.get("okAndOr"):
		npc.set("startingDialog", "25")

func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))

signal openDoor(doorNumber)
@warning_ignore("UNUSED_SIGNAL")
signal closeDoor(doorNumber)
signal enableTorches(roomNumber)
