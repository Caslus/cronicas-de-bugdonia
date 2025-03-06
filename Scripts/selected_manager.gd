extends Node

@export var selected: Node = null;
var shader = load("res://Shaders/Glitch.gdshader")

signal selected_changed
signal selected_edited

func set_shader_recursive(node: Node, newShader: Shader):
	if node is Sprite2D:
		if newShader == null:
			if node.material:
				node.material = null
		else:
			node.material = ShaderMaterial.new()
			node.material.shader = newShader
	for child in node.get_children():
		set_shader_recursive(child, newShader)

func set_selected(new_selected: Node) -> void:
	if selected != null:
		set_shader_recursive(selected.get_node("Sprite"), null)

	if new_selected == null:
		selected = null
		emit_signal("selected_changed")
		return

	selected = new_selected
	set_shader_recursive(selected.get_node("Sprite"), shader)

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
