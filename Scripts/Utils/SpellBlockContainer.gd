extends Control

signal  config_saved(new_config: Dictionary, index: int)

@export var spellBlockConfig: PackedScene

var spellBlock = ""
var config = {}

func set_config(block: SpellBlock, index: int) -> void:
	if block.icon != null:
		get_node("PanelContainer").get_node("Button").icon = block.icon
		get_node("PanelContainer").get_node("Button").text = ""
	else:
		get_node("PanelContainer").get_node("Button").text = block.shortName
	get_node("PanelContainer").get_node("Button").tooltip_text = block.name + "\n" + block.description
	set_meta("index", index)

	if block.shortName == "For":
		get_node("Label").text = str(block.config["contagem"])
	elif block.shortName == "Tempo":
		get_node("Label").text = str(block.config["tempo"])
	else:
		get_node("Label").text = ""

	spellBlock = block.name
	config = block.config

func set_action(action: Callable) -> void:
	get_node("PanelContainer").get_node("Button").pressed.connect(func():
		action.call()
	)

func add_config_ui() -> void:
	var configUI: Control = spellBlockConfig.instantiate()
	# configUI will float below the button
	configUI.position = Vector2(116, 130)
	configUI.z_index = 1

	configUI.get_node("Editor").get_node("VBoxContainer").get_node("HBoxContainer").get_node("Buttons").get_node("CloseEditorButton").pressed.connect(func():
		close_config_ui()
	)

	configUI.set_label(spellBlock)
	configUI.add_options(config)

	configUI.connect("config_saved", Callable(self, "connectSaved"))

	add_child(configUI)
	close_config_ui()

	# if get_node("PanelContainer").get_node("Button") is pressed with the right mouse button, open the config UI
	get_node("PanelContainer").get_node("Button").gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			open_config_ui()
	)

func open_config_ui() -> void:
	get_node("SpellBlockConfig").visible = true

func close_config_ui() -> void:
	get_node("SpellBlockConfig").visible = false

func connectSaved(new_config: Dictionary) -> void:
	emit_signal("config_saved", new_config, get_meta("index"))
