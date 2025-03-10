extends Node2D

@export var animation_tree: AnimationTree
@onready var character: CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	var idle = !character.velocity.x and !character.velocity.y
	var moving = character.velocity.x and !character.velocity.y
	var jumping = character.velocity.y != 0

	# flip the sprite based on the direction
	if character.velocity.x > 0:
		character.get_node("Sprite").scale.x = -1
	elif character.velocity.x < 0:
		character.get_node("Sprite").scale.x = 1

	animation_tree.set("parameters/walk/TimeScale/scale", character.velocity.x / 300.0)
	
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/walk", moving)
	animation_tree.set("parameters/conditions/fall", jumping)
