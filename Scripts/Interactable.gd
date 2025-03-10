extends Node2D

@export var enableExclamation: bool = true
@onready var exclamation: Sprite2D = get_node("Exclamation")
@onready var exclamationAnimationPlayer: AnimationPlayer = exclamation.get_node("AnimationPlayer")
@onready var area: Area2D = get_node("Area2D")

signal interactable(npc)

func _ready():
	area.connect("body_entered", Callable(self, "_on_body_entered"))
	area.connect("body_exited", Callable(self, "_on_body_exited"))
	exclamationAnimationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _on_body_entered(body):
	if body.name == "Player":
		activate_interactable()

func _on_body_exited(body):
	if body.name == "Player":
		deactivate_interactable()

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
