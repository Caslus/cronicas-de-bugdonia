extends StaticBody2D

@export var VAR_LOCKED: bool = true
@export var door: StaticBody2D = null

var openedBefore: bool = false

func open_door():
  openedBefore = true
  VAR_LOCKED = false
  SelectedManager.set_selected(null)
  get_node("CollisionShape2D").disabled = true
  var group = get_parent()
  var doorTween = create_tween()
  doorTween.set_ease(Tween.EaseType.EASE_IN_OUT)
  doorTween.tween_property(group, "position", group.position + Vector2(50, -550), 1)
  QuestManager.toggleQuestVar("opened")

func _process(_delta):
  if not VAR_LOCKED and not openedBefore:
    open_door()