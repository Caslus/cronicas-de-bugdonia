extends Control

signal config_saved(new_config: Dictionary)

@export var spellBlockConfigOption: PackedScene

func set_label(newName: String) -> void:
	get_node("Editor").get_node("VBoxContainer").get_node("HBoxContainer").get_node("Label").text = newName

func add_options(config: Dictionary) -> void:
	for child in get_node("Editor").get_node("VBoxContainer").get_node("ConfigOptions").get_children():
		child.queue_free()
	for key in config.keys():
		var option = spellBlockConfigOption.instantiate()
		option.get_node("Label").text = key.capitalize()
		option.get_node("LineEdit").text = str(config[key])
		get_node("Editor").get_node("VBoxContainer").get_node("ConfigOptions").add_child(option)

func on_save_pressed() -> void:
	var newConfig = {}
	for child in get_node("Editor").get_node("VBoxContainer").get_node("ConfigOptions").get_children():
		var key = child.get_node("Label").text.to_lower()
		var value: String = child.get_node("LineEdit").text
		if value.is_valid_float():
			if value.is_valid_int():
				newConfig[key] = int(value)
			else:
				newConfig[key] = float(value)
		else:
			newConfig[key] = value
	emit_signal("config_saved", newConfig)
