extends Node

var currentQuest: Node = null

signal questVariablesChanged()

func getQuestVar(varName: String) -> Variant:
	var questVariables: Dictionary = currentQuest.get("questVariables")
	return questVariables.get(varName)

func toggleQuestVar(varName: String) -> void:
	var questVariables: Dictionary = currentQuest.get("questVariables")
	var currentValue: Variant = questVariables.get(varName)
	questVariables.set(varName, !currentValue)
	emit_signal("questVariablesChanged")

func _ready():
	pass
