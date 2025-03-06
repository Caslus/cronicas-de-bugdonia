extends Node2D

@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@onready var player: CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	var idle = !player.velocity.x and !player.velocity.y
	var moving = player.velocity.x and !player.velocity.y
	var jumping = player.velocity.y != 0

	# flip the sprite based on the direction
	if player.velocity.x > 0:
		player.get_node("Sprite").scale.x = -1 * 0.113
	elif player.velocity.x < 0:
		player.get_node("Sprite").scale.x = 1 * 0.113

	
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/walk", moving)
	animation_tree.set("parameters/conditions/fall", jumping)
