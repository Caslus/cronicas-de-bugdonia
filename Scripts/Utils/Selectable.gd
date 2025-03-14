extends Sprite2D

@onready var collision = get_parent()
@onready var player = get_tree().get_nodes_in_group("player")[0]

func interactable() -> bool:
	if not collision.has_meta("Interactable"): return false
	return collision.get_meta("Interactable")

func _on_mouse_entered():
	if player.get("hasWand") == false: return
	if interactable() == false: return
	
	if SelectedManager.selected != collision:
		visible = true;

func _on_mouse_exited():
	visible = false;

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if player.get("hasWand") == false: return
		if interactable() == false: return
		visible = false;
		SelectedManager.set_selected(collision)

func _ready():
	collision.connect("mouse_entered", Callable(self, "_on_mouse_entered"));
	collision.connect("mouse_exited", Callable(self, "_on_mouse_exited"));
	collision.connect("input_event", Callable(self, "_on_input_event"));
