extends Node2D

@onready var player: CharacterBody2D = get_parent()

@export var coyoteTime: float = 0.15

var coyoteTimer: float = 0

func _ready():
	pass

func _physics_process(delta: float) -> void:
	if player.get("BEING_RESPAWNED"):
		player.velocity = Vector2(0, 0)
		player.position = player.position
		return
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		coyoteTimer -= delta
	else:
		coyoteTimer = coyoteTime
	
	if player.get("VAR_USE_GRAVITY"):
			player.velocity += player.get_gravity() * delta
	else:
		player.velocity -= player.get_gravity() * delta * 2
	
	player.velocity.y = clamp(player.velocity.y, -1000.0, 1000.0)

	var canMove = player.get("CAN_MOVE")
	
	if Input.is_key_pressed(KEY_SPACE) and canMove:
		if player.is_on_floor() or coyoteTimer > 0:
			player.velocity.y = player.get("JUMP_VELOCITY") * -60
			coyoteTimer = 0
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and canMove:
		if Input.is_key_pressed((KEY_SHIFT)):
			player.velocity.x = direction * player.get("VAR_SPEED") * 30 * player.get("RUN_MULTIPLIER")
		else:
			player.velocity.x = direction * player.get("VAR_SPEED") * 30
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.get("VAR_SPEED") * 30)

	player.move_and_slide()
