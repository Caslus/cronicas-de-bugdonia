extends CharacterBody2D

@export var VAR_NAME: String = "Hero"
@export var VAR_SPEED: float = 10.0
@export var JUMP_VELOCITY: float = 14.5
@export var VAR_INT: int = 13
@export var VAR_USE_GRAVITY: bool = true
@export var RUN_MULTIPLIER: float = 1.5
@export var CAN_MOVE: bool = true
@export var BEING_RESPAWNED: bool = false
@export var RESPAWN_POINT: Vector2 = Vector2(0, 0)
@export var hasWand: bool = false

# camera
@export var CAMERA_LIMIT_LEFT: int = -1000
@export var CAMERA_LIMIT_RIGHT: int = 1000000
@export var CAMERA_LIMIT_TOP: int = -2000
@export var CAMERA_LIMIT_BOTTOM: int = 460
@onready var camera: Camera2D = get_node("Camera2D")


func changeCameraLimits(left: int, right: int, top: int, bottom: int) -> void:
	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom

func giveWand() -> void:
	hasWand = true
	self.get_node("Sprite/l_arm/MagicWand").visible = true

func _ready():
	changeCameraLimits(CAMERA_LIMIT_LEFT, CAMERA_LIMIT_RIGHT, CAMERA_LIMIT_TOP, CAMERA_LIMIT_BOTTOM)
	if hasWand:
		giveWand()
