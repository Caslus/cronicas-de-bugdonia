extends Node

var currentQuest: Node = null

signal questVariablesChanged()
signal questChanged()

func getQuestVar(varName: String) -> Variant:
	var questVariables: Dictionary = currentQuest.get("questVariables")
	return questVariables.get(varName)

func toggleQuestVar(varName: String) -> void:
	if(!currentQuest):
		return
	var questVariables: Dictionary = currentQuest.get("questVariables")
	var currentValue: Variant = questVariables.get(varName)
	questVariables.set(varName, !currentValue)
	emit_signal("questVariablesChanged")
	
func setCurrentQuest(newQuest: Node) -> void:
	currentQuest = newQuest
	emit_signal("questChanged")

func _ready():
	pass
