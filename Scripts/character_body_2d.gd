extends CharacterBody2D

@export var VAR_NAME: String = "Hero"
@export var VAR_SPEED: float = 10.0
@export var VAR_JUMP_VELOCITY: float = 14.5
@export var VAR_INT: int = 13
@export var VAR_USE_GRAVITY: bool = true


func _ready():
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if VAR_USE_GRAVITY:
		velocity += get_gravity() * delta
	else:
		velocity -= get_gravity() * delta * 2

	var canMove = SelectedManager.selected == null
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and canMove:
		velocity.y = VAR_JUMP_VELOCITY * -60

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction and canMove:
		velocity.x = direction * VAR_SPEED * 30
	else:
		velocity.x = move_toward(velocity.x, 0, VAR_SPEED * 30)

	move_and_slide()
