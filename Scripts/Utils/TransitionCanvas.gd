extends CanvasLayer

signal on_transition_finished

@onready var rect = $ColorRect
@onready var player = $AnimationPlayer

func _ready() -> void:
		rect.visible = false
		player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim) -> void:
	if anim == "FadeToBlack":
		on_transition_finished.emit()
		player.play("FadeToNormal")
	elif anim == "FadeToNormal":
		rect.visible = false

func transition() -> void:
	rect.visible = true
	player.play("FadeToBlack")
	 	
