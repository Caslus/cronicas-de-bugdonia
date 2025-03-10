extends CharacterBody2D

@export var dialogFile: String = "res://Dialog/NPC_Test.json"
@export var dialog: Dictionary = {}

func load_dialog():
	var file = FileAccess.open(dialogFile, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	for i in range(content.size()):
		dialog[content[i]["id"]] = content[i]
	file.close()


func _ready():
	load_dialog()
	pass
