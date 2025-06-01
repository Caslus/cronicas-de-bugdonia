extends Node2D

@export var enableExclamation: bool = true
@export var enableInteraction: bool = true
@onready var exclamation: Sprite2D = get_node("Exclamation")
@onready var exclamationAnimationPlayer: AnimationPlayer = exclamation.get_node("AnimationPlayer")
@onready var area: Area2D = get_node("Area2D")
@onready var player: CharacterBody2D = get_tree().get_nodes_in_group("player")[0]

signal interactable(npc)

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	area.connect("input_event", Callable(self, "_on_input_event"))
	exclamationAnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _on_body_entered(body):
	if body.name == "Player" and enableInteraction:
		activate_interactable()

func _on_body_exited(body):
	if body.name == "Player":
		deactivate_interactable()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		player.get_node("InteractionManager").start_interaction()

func activate_interactable():
	interactable.emit(self.get_parent())
	if enableExclamation:
		exclamation.visible = true
	exclamationAnimationPlayer.play("popin")

func deactivate_interactable():
	interactable.emit(null)
	exclamationAnimationPlayer.play("popout")


func _on_animation_finished(animation_name):
	if animation_name == "popout":
		exclamation.visible = false
	elif animation_name == "popin":
		exclamationAnimationPlayer.play("hover")

func _process(_delta):
	if not enableExclamation:
		exclamationAnimationPlayer.play("popout")
