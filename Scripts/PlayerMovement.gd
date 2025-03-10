extends Node2D

@onready var player: CharacterBody2D = get_parent()

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	if player.get("VAR_USE_GRAVITY"):
		player.velocity += player.get_gravity() * delta
	else:
		player.velocity -= player.get_gravity() * delta * 2
	
	player.velocity.y = clamp(player.velocity.y, -1000.0, 1000.0)

	var canMove = player.get("CAN_MOVE")
	# Handle jump.
	if Input.is_key_pressed(KEY_SPACE) and player.is_on_floor() and canMove:
		player.velocity.y = player.get("JUMP_VELOCITY") * -60

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and canMove:
		if Input.is_key_pressed((KEY_SHIFT)):
			player.velocity.x = direction * player.get("VAR_SPEED") * 30 * player.get("RUN_MULTIPLIER")
		else:
			player.velocity.x = direction * player.get("VAR_SPEED") * 30
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.get("VAR_SPEED") * 30)

	player.move_and_slide()
