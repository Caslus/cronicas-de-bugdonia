extends Node

var currentQuest: Node = null

signal questVariablesChanged()
signal questChanged()

func getQuestVar(varName: String) -> Variant:
	var questVariables: Dictionary = currentQuest.get("questVariables")
	return questVariables.get(varName)

func toggleQuestVar(varName: String) -> void:
	if not currentQuest:
		return
	var questVariables: Dictionary = currentQuest.get("questVariables")
	var currentValue: Variant = questVariables.get(varName)
	questVariables.set(varName, !currentValue)
	emit_signal("questVariablesChanged")

func setQuestVar(varName: String, value: bool) -> void:
	if not currentQuest:
		return
	var questVariables: Dictionary = currentQuest.get("questVariables")
	questVariables.set(varName, value)
	emit_signal("questVariablesChanged")
	
func setCurrentQuest(newQuest: Node) -> void:
	currentQuest = newQuest
	emit_signal("questChanged")

func moveNpcTo(npcName: String, pos: Vector2, speed: float) -> void:
	emit_signal("moveNpc", npcName, pos, speed)

func _ready():
	pass

signal moveNpc(npcName: String, pos: Vector2, speed: float)
