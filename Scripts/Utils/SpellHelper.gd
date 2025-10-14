extends Node

@export var grid: GridContainer
@export var dragon: Sprite2D
@export var explosionScene: PackedScene

func spawn_text(text: String) -> void:
	var infoText = Label.new()
	infoText.text = text
	infoText.add_theme_color_override("font_color", Color(255, 255, 255))
	infoText.set_position(get_parent().get_parent().global_position + Vector2(65, 0))
	infoText.z_index = 100
	infoText.add_theme_font_size_override("font_size", 24)
	get_tree().current_scene.add_child(infoText)
	var tween = infoText.create_tween()
	tween.tween_property(infoText, "modulate:a", -1, 1.5).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(infoText, "queue_free"))


func spawn_explosion(coluna: int, linha: int) -> void:
		if !grid or !dragon: return
		# bound check, grid is square
		if (coluna < 0 or coluna >= grid.get("gridColumns")) or (linha < 0 or linha >= grid.get("cellCount") / grid.get("gridColumns")):
			get_parent().fail_spell()
			spawn_text("Coluna ou linha inválida.")
			return
		var explosion = explosionScene.instantiate()
		if !explosion: return
		var cell_size = grid.get("cellSize")
		var posX = coluna * cell_size + cell_size / 2
		var posY = linha * cell_size + cell_size / 2
		explosion.position = Vector2(posX, posY)
		grid.add_child(explosion)
		explosion.get_node("GPUParticles2D").emitting = true

		var dragonCurrentCell = dragon.get("currentCell")
		if dragonCurrentCell.x == coluna and dragonCurrentCell.y == linha:
			if dragon.has_method("take_damage"):
				dragon.call("take_damage", 20)


		await explosion.get_node("GPUParticles2D").finished
		explosion.queue_free()
