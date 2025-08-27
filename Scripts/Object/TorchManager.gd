extends Node

@export var quest: Node
var torches: Array[Node] = []

@onready var solutionChecker = get_parent().get_node("SolutionChecker")

func _ready() -> void:
	torches = get_parent().get_children().filter(func(c):
		return c is Node and c.name.begins_with("Torch") and c!=self
	)
	for torch in torches:
		torch.editableVars = []

	quest.connect("enableTorches", Callable(self, "enableTorches"))

func enableTorches(roomNumber: int) -> void:
	if solutionChecker.doorNumber != roomNumber: return
	for torch in torches:
		torch.editableVars = ["VAR_ACESA"]
