extends Node

func round_to_dec(num, digit):
		return round(num * pow(10.0, digit)) / pow(10.0, digit)

func set_shader_recursive(node: Node, newShader: Shader):
	if node is Sprite2D:
		if newShader == null:
			if node.material:
				node.material = null
		else:
			node.material = ShaderMaterial.new()
			node.material.shader = newShader
	if node.get_child_count() > 0:
		for child in node.get_children():
			set_shader_recursive(child, newShader)
