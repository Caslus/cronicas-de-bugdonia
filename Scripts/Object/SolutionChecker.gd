extends Node

@export var solution: Dictionary = {
	# <NodePath, boolean>
	# Fireholder, true
	# Fireholder1, false
	# Fireholder2, true
}
@export var doorNumber: int = 0

func connect_signals() -> void:
	for node: NodePath in solution.keys():
		var fireholder = get_node(node)
		if not fireholder:
			pass
		fireholder.connect("fireholderChanged", Callable(self, "check_all"))

func check_solution() -> bool:
	var okCount: int = 0
	for node: NodePath in solution.keys():
		var fireholder = get_node(node)
		if not fireholder:
			return false
		var expected: bool = solution[node]
		var actual: bool = fireholder.get("VAR_ACESA")
		if expected == actual:
			okCount += 1
	return okCount == solution.size()

func check_all() -> void:
	if check_solution():
		QuestManager.currentQuest.emit_signal("openDoor", doorNumber)
	else:
		QuestManager.currentQuest.emit_signal("closeDoor", doorNumber)

func _ready() -> void:
	connect_signals()
