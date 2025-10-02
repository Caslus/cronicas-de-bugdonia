extends Node2D

@export var speed: float = 400.0
@export var lifetime: float = 2.0
@export var explodeParticles: PackedScene
var velocity: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

var indice: int = 0
var valor: int = 0

func spawn_text(text: String) -> void:
	var infoText = Label.new()
	infoText.text = text
	infoText.add_theme_color_override("font_color", Color(255, 255, 255))
	infoText.set_position(global_position)
	infoText.z_index = 100
	infoText.add_theme_font_size_override("font_size", 24)
	get_tree().current_scene.add_child(infoText)
	var tween = infoText.create_tween()
	tween.tween_property(infoText, "modulate:a", -1, 1.5).as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(infoText, "queue_free"))

func despawn(hit: Node) -> void:
	if hit != null and hit.has_method("set_index"):
		if hit.get_size() > indice:
			var infoText = "[" + str(indice) + "] = "+ str(valor)
			spawn_text(infoText)
		else:
			spawn_text("Índice inválido...")
	else:
		spawn_text("Nada aconteceu...")
	queue_free()

func _process(delta):
		position += velocity * delta
		time_alive += delta
		if time_alive > lifetime:
			despawn(null)

func _on_body_entered(body: Node) -> void:
		if body.is_in_group("player"): return
		if body.has_method("set_index"):
			body.set_index(indice, valor)
		despawn(body)

func set_config(_index: int, _value: int) -> void:
		indice = _index
		valor = _value
