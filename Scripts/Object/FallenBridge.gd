extends Node2D

@export var dialogFile: String = "res://Dialog/FallenBridge.json"
var dialog: Dictionary = {}
@export var startingDialog: String = "1"
@export var quest: Node = null

func load_dialog():
	var file = FileAccess.open(dialogFile, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	for i in range(content.size()):
		dialog[content[i]["id"]] = content[i]
	file.close()

func _ready():
	load_dialog()
	pass
