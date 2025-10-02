extends Sprite2D

var spinning: bool = false

func setup(number: int) -> void:
	var label = get_node("Label") as Label
	label.text = str(number)

func spin(times: int) -> void:
	if spinning: return
	spinning = true
	for i in range(times):
		var tween = create_tween()
		tween.tween_property(self, "rotation_degrees", rotation_degrees + 360, 1.0).set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.play()
		await tween.finished
		# wait a short moment before the next spin
		await get_tree().create_timer(0.1).timeout
	spinning = false
