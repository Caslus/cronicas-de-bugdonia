extends StaticBody2D

@export var VAR_TRANCADO: bool = true

var openedBefore: bool = false

@export var editableVars: Array = []

func open_door():
	openedBefore = true
	VAR_TRANCADO = false
	SelectedManager.set_selected(null)
	get_node("CollisionShape2D").disabled = true
	var group = get_parent()
	var doorTween = create_tween()
	doorTween.set_ease(Tween.EaseType.EASE_IN_OUT)
	doorTween.tween_property(group, "position", group.position + Vector2(50, -550), 1)
	QuestManager.toggleQuestVar("finished")
	await doorTween.finished
	group.visible = false

func _process(_delta):
	if not VAR_TRANCADO and not openedBefore:
		open_door()
