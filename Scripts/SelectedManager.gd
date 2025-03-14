extends Node

@export var selected: Node = null;
var shader = load("res://Shaders/Glitch.gdshader")
@onready var player = get_tree().get_nodes_in_group("player")[0]

signal selected_changed
signal selected_edited

func set_selected(new_selected: Node) -> void:
	if selected != null:
		Utils.set_shader_recursive(selected.get_node("Sprite"), null)

	if new_selected == null:
		selected = null
		emit_signal("selected_changed")
		return

	selected = new_selected
	Utils.set_shader_recursive(selected.get_node("Sprite"), shader)

	emit_signal("selected_changed")

func edit_number(property: String, value: float) -> void:
	if selected != null:
		selected.set(property, value)
		emit_signal("selected_edited")

func edit_string(property: String, value: String) -> void:
	if selected != null:
		selected.set(property, value)
		emit_signal("selected_edited")

func edit_boolean(property: String, value: bool) -> void:
	if selected != null:
		selected.set(property, value)
		emit_signal("selected_edited")


func _ready():
		pass
