extends Node2D

@onready var animPlayer: AnimationPlayer = $AnimationPlayer

func _ready():
	animPlayer.play("start")
	await animPlayer.animation_finished
	animPlayer.play("end")
	await animPlayer.animation_finished
	queue_free()
