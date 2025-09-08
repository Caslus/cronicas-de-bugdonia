extends Node

@export var questName: String = "Funções? Loops?"
@export var questDescription: String = "Aprenda a usar funções e loops destruindo pedras."
@export var questVariables: Dictionary = {
	"initialTalk": false,
	"destroyedRock1": false,
	"learned_loop": false,
	"destroyedRock2": false,
	"destroyedRock3": false,
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

func moveNpc(pos: Vector2, speed: float = 4.0) -> void:
	if npc.position.x > pos.x: return
	if npc.position != pos and not npc.moving:
		QuestManager.moveNpcTo(npc.get_meta("objectName"), pos, speed)

func onUpdateQuestVariables():
	if questVariables.get("initialTalk"):
		npc.set("startingDialog", "8")

func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
