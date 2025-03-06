extends Sprite2D

@onready var collision = get_parent()

func _on_mouse_entered():
	if SelectedManager.selected != get_parent():
		visible = true;

func _on_mouse_exited():
	visible = false;

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		visible = false;
		SelectedManager.set_selected(get_parent())

func _ready():
	collision.connect("mouse_entered", Callable(self, "_on_mouse_entered"));
	collision.connect("mouse_exited", Callable(self, "_on_mouse_exited"));
	collision.connect("input_event", Callable(self, "_on_input_event"));
