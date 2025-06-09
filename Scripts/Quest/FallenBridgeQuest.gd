extends Node

@export var questName: String = "Quest Name"
@export var questDescription: String = "Quest Description"
@export var questVariables: Dictionary = {}

@export var floatingPlatform: AnimatableBody2D
@export var fallenBridge: Node2D

@export var nextQuest: Node

var broughtPlatformOnce: bool = false
var numberFalls: int = 0

func animatePlatform():
	var tweenPosition = create_tween()
	tweenPosition.set_ease(Tween.EASE_IN_OUT)
	tweenPosition.tween_property(floatingPlatform, "position", Vector2(floatingPlatform.position.x, 500), 1.0)
	tweenPosition.tween_property(floatingPlatform, "position", Vector2(13000, 500), 3.0)
	tweenPosition.tween_property(floatingPlatform, "position", Vector2(13000, 161), 3.0)
	await tweenPosition.finished

func onUpdateQuestVariables():
	if questVariables.get("talked"):
		fallenBridge.set("startingDialog", "4")
		if !broughtPlatformOnce:
			floatingPlatform.set("VAR_VELOCIDADE_HORIZONTAL", -100)
		if questVariables.get("fell"):
			numberFalls+=1
			animatePlatform()
			floatingPlatform.set("VAR_VELOCIDADE_HORIZONTAL", -100)
			questVariables.set("fell", false)
		if questVariables.get("passed"):
			fallenBridge.set("startingDialog", "7")
			QuestManager.setCurrentQuest(nextQuest)


func _ready():
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
