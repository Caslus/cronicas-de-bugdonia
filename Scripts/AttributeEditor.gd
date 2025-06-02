extends Node

@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]
@onready var ui: CanvasLayer = $AttributeEditorUI
@onready var header: HBoxContainer = $AttributeEditorUI/Panel/MarginContainer/VBox/Header
@onready var attributeList: VBoxContainer = $AttributeEditorUI/Panel/MarginContainer/VBox/AttributeList

var booleanEditorScene: PackedScene = preload("res://Scenes/Utils/BooleanEdit.tscn")
var intEditorScene: PackedScene = preload("res://Scenes/Utils/IntEdit.tscn")
var floatEditorScene: PackedScene = preload("res://Scenes/Utils/FloatEdit.tscn")
var stringEditorScene: PackedScene = preload("res://Scenes/Utils/StringEdit.tscn")

func formatPropertyName(selected, propName) -> String:
	var value = str(selected.get(propName))
	var text = propName.replace("VAR_", "")
	return text + ": " + value


func get_variables():
	var properties = []

	var selected = SelectedManager.selected;

	if selected == null:
		return properties

	for property in selected.get_property_list():
		if property.get("name").begins_with("VAR_") and property.get("name") in selected.get("editableVars"):
			properties.append(property)
	return properties

func create_editor_header(selected):
	var headerNameLabel = header.get_node("SelectedName")
	var headerCloseButton = header.get_node("Button")
	if (selected.get_meta("objectName") != null):
		headerNameLabel.text = selected.get_meta("objectName")
	else:
		headerNameLabel.text = "Objeto"

	headerCloseButton.connect("pressed", Callable(self, "_on_close_button_pressed"))

func create_float_editor(selected, prop):
	var floatEdit = floatEditorScene.instantiate()
	var nameLabel = floatEdit.get_node("Label").get_node("AttributeName")
	nameLabel.text = str(prop.name).replace("VAR_", "") + ":"
	var valueLabel = floatEdit.get_node("Label").get_node("Value")
	valueLabel.text = str(selected.get(prop.name))
	var buttonMinus = floatEdit.get_node("ButtonMinus")
	buttonMinus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, -1, valueLabel))
	var buttonPlus = floatEdit.get_node("ButtonPlus")
	buttonPlus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, 1, valueLabel))
	attributeList.add_child(floatEdit)

func create_int_editor(selected, prop):
	var intEdit = intEditorScene.instantiate()
	var nameLabel = intEdit.get_node("Label").get_node("AttributeName")
	nameLabel.text = str(prop.name).replace("VAR_", "") + ":"
	var valueLabel = intEdit.get_node("Label").get_node("Value")
	valueLabel.text = str(selected.get(prop.name))
	var buttonMinus = intEdit.get_node("ButtonMinus")
	buttonMinus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, -1, valueLabel))
	var buttonPlus = intEdit.get_node("ButtonPlus")
	buttonPlus.connect("pressed", Callable(self, "_on_button_pressed").bind(prop.name, 1, valueLabel))
	attributeList.add_child(intEdit)

func create_string_editor(selected, prop):
	var stringEdit = stringEditorScene.instantiate()
	var nameLabel = stringEdit.get_node("AttributeName")
	nameLabel.text = prop.name.replace("VAR_", "") + ":"
	var lineEdit = stringEdit.get_node("LineEdit")
	lineEdit.text = selected.get(prop.name)
	lineEdit.connect("text_changed", Callable(self, "_on_text_changed").bind(prop.name))
	attributeList.add_child(stringEdit)

func create_boolean_editor(selected, prop):
	var booleanEdit = booleanEditorScene.instantiate()
	var nameLabel = booleanEdit.get_node("AttributeName")
	nameLabel.text = formatPropertyName(selected, prop.name)

	var buttonToggle = booleanEdit.get_node("ButtonToggle")
	buttonToggle.connect("pressed", Callable(self, "_on_toggle_button_pressed").bind(prop.name, nameLabel))
	attributeList.add_child(booleanEdit)

func create_ui():
	if SelectedManager.selected == null:
		ui.visible = false
		return
	
	ui.visible = true
	for child in attributeList.get_children():
		attributeList.remove_child(child)

	var selected = SelectedManager.selected;
	var properties = get_variables()

	if properties.size() == 0:
		return

	create_editor_header(selected)
	
	for prop in properties:
		if prop.type == TYPE_FLOAT:
			create_float_editor(selected, prop)
		elif prop.type == TYPE_INT:
			create_int_editor(selected, prop)
		elif prop.type == TYPE_STRING:
			create_string_editor(selected, prop)
		elif prop.type == TYPE_BOOL:
			create_boolean_editor(selected, prop)
			
func _on_close_button_pressed():
		SelectedManager.set_selected(null)
		ui.visible = false

func _on_button_pressed(prop_name, change, value_label):
		var selected = SelectedManager.selected
		var current_value = selected.get(prop_name)
		if Input.is_key_pressed(KEY_SHIFT):
			change *= 10
		elif Input.is_key_pressed(KEY_CTRL) and typeof(current_value) == TYPE_FLOAT:
			if change > 0:
				change = 0.5
			else:
				change = -0.5
		current_value += change
		SelectedManager.edit_number(prop_name, current_value)
		value_label.text = str(current_value)

func _on_text_changed(new_text, propName):
		SelectedManager.edit_string(propName, new_text)

func _on_toggle_button_pressed(propName, value_label):
		var selected = SelectedManager.selected
		var current_value = selected.get(propName)
		current_value = !current_value
		SelectedManager.edit_boolean(propName, current_value)
		value_label.text = formatPropertyName(selected, propName)

func _ready() -> void:
	SelectedManager.selected_changed.connect(create_ui)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_clear_carets_and_selection"):
		if ui.visible:
			_on_close_button_pressed()
