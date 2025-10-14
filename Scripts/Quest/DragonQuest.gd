extends Node

@export var questName: String = "Tiro no Dragão"
@export var questDescription: String = "Ajude o mago a derrotar o dragão utilizando matrizes."
@export var questVariables: Dictionary = {
	"teachExplosion": false,
	"fightStarted": false,
	"allowedToZoomOut": false,
	"finished": false
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

@export var spellManager: Node = null
@export var spellEditor: Control = null

@export var tipUI: PackedScene
@export_multiline var tipText: String

var challengeTimer: Timer = null
@export var tipWaitTime: float = 90.0

@export var player: CharacterBody2D
@onready var camera: Camera2D = player.get_node("Camera2D")
@onready var originalZoom: Vector2 = camera.zoom
@onready var originalLimitBottom: int = camera.limit_bottom
var zoomedOut: bool = false

func zoomOut():
	var tweenZoom = create_tween()
	tweenZoom.set_ease(Tween.EASE_IN_OUT)
	tweenZoom.tween_property(camera, "zoom", Vector2(0.5, 0.5), 1.0)
	var tweenLimit = create_tween()
	tweenLimit.set_ease(Tween.EASE_IN_OUT)
	tweenLimit.tween_property(camera, "limit_bottom", 340, 1.0)
	pass

func zoomIn():
	var tweenZoom = create_tween()
	tweenZoom.set_ease(Tween.EASE_IN_OUT)
	tweenZoom.tween_property(camera, "zoom", originalZoom, 1.0)
	var tweenLimit = create_tween()
	tweenLimit.set_ease(Tween.EASE_IN_OUT)
	tweenLimit.tween_property(camera, "limit_bottom", originalLimitBottom, 1.0)
	pass

func startChallenges():
	if challengeTimer != null: return
	challengeTimer = Timer.new()
	challengeTimer.wait_time = tipWaitTime
	challengeTimer.one_shot = true
	challengeTimer.connect("timeout", Callable(self, "onChallengeTimeout"))
	add_child(challengeTimer)
	challengeTimer.start()

func onChallengeTimeout():
	var tipInstance = tipUI.instantiate()
	tipInstance.setTipText(tipText)
	add_child(tipInstance)

func onUpdateQuestVariables():
	if questVariables.get("teachExplosion"):
		spellManager.allowedToCast = true
		spellEditor.allowedToUseEditor = true
		spellManager.learn_rune("explosao")
		spellManager.learn_rune("for")
		spellManager.learn_rune("forend")
		spellManager.learn_rune("tempo")
	if questVariables.get("fightStarted"):
		startChallenges()
		spellManager.get_node("SpellHelper").dragon.get_node("HealthBar").get_node("CanvasLayer").visible = true
	if questVariables.get("allowedToZoomOut") and not questVariables.get("finished"):
		npc.set("startingDialog", "9c")
		var tipInstance = tipUI.instantiate()
		tipInstance.setTipText("Pressione a tecla Z para afastar a câmera e ter uma visão melhor da matriz.")
		add_child(tipInstance)
	if questVariables.get("finished"):
		npc.set("startingDialog", "10")
		questVariables["allowedToZoomOut"] = false
		if zoomedOut:
			zoomIn()
			zoomedOut = false
		

func _ready():
	RenderingServer.set_default_clear_color(Color(0.208, 0.208, 0.251))
	QuestManager.currentQuest = self
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))

# if Z key is pressed, zoom out the camera
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_out") and questVariables.get("allowedToZoomOut"):
		if !zoomedOut:
			zoomOut()
			zoomedOut = true
		else:
			zoomIn()
			zoomedOut = false
