extends Sprite2D

@export var xOffset: float = 0

@onready var player: CharacterBody2D = get_node("../Player")
var originalZIndex: int

func _ready() -> void:
  originalZIndex = z_index

func _process(_delta: float) -> void:
  if player.global_position.x > global_position.x + xOffset:
    z_index = player.z_index + 10
  else:
    z_index = originalZIndex