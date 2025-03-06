extends Area2D

@export var VAR_NAME: String = "Rodolfo"

@onready var label: Label = get_node("Label")

func _on_selected_edited():
  label.text = VAR_NAME

func _ready():
  SelectedManager.connect("selected_edited", Callable(self, "_on_selected_edited"))
  label.text = VAR_NAME
