extends Area2D

func respawn_player(player):
	var respawnNode: Node2D = player.get_node("Respawn")
	var godHand: Sprite2D = respawnNode.get_node("GodHand")
	godHand.position = Vector2(-123.0, -2000.0)
	player.CAN_MOVE = false
	player.BEING_RESPAWNED = true
	var playerCollision: CollisionShape2D = player.get_node("CollisionShape2D")
	playerCollision.disabled = true

	godHand.visible = true
	var godRays: Sprite2D = respawnNode.get_node("Godrays")
	godRays.visible = true
	var tweenGodrays = create_tween()
	tweenGodrays.set_ease(Tween.EASE_IN_OUT)
	tweenGodrays.tween_property(godRays.material, "shader_parameter/edge_fade", 0.111, 3.0)

	var tweenGodHandDown = create_tween()
	tweenGodHandDown.set_ease(Tween.EASE_IN_OUT)
	tweenGodHandDown.tween_property(godHand, "position", Vector2(godHand.position.x, -445.0), 5.0)
	await tweenGodHandDown.finished

	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	tweenPosition.tween_property(player, "position", Vector2(player.position.x, -1000.0), 2.0)
	tweenPosition.tween_property(player, "position", Vector2(player.RESPAWN_POINT.x, -1000.0), 2.0)
	tweenPosition.tween_property(player, "position", player.RESPAWN_POINT, 2.0)
	await tweenPosition.finished

	player.BEING_RESPAWNED = false
	playerCollision.disabled = false
	
	var tweenHandPosition = create_tween()
	tweenHandPosition.set_ease(Tween.EASE_IN_OUT)
	tweenHandPosition.tween_property(godHand, "position", Vector2(godHand.position.x, -2000.0), 0.5)
	await tweenHandPosition.finished

	godHand.visible = false
	var tweenGodrays2 = create_tween()
	tweenGodrays2.set_ease(Tween.EASE_IN_OUT)
	tweenGodrays2.tween_property(godRays.material, "shader_parameter/edge_fade", 1.0, 0.25)
	await tweenGodrays2.finished

	godRays.visible = false
	player.CAN_MOVE = true


func _on_body_entered(body):
	if body.name == "Player":
		respawn_player(body)


func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
