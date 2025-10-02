extends Node

@export var questName: String = "Funções? Loops?"
@export var questDescription: String = "Aprenda a usar funções e loops destruindo pedras."
@export var questVariables: Dictionary = {
	"initialTalk": false,
	"destroyedRock1": false,
	"initialLoop": false,
	"learned_loop": false,
	"destroyedRock2": false,
	"destroyedRock3": false,
}
@export var npc: CharacterBody2D = null
@export var nextQuest: Node

@export var spellManager: Node = null
@export var spellEditor: Control = null

@export var rock1: Node2D = null
@export var rock2: Node2D = null
@export var rock3: Node2D = null

@export var tipUI: PackedScene
@export_multiline var tipText: String
@export_multiline var tipText2: String

var challengeTimer: Timer = null
@export var tipWaitTime: float = 90.0

func startChallenges():
	print("Starting challenges...")
	if challengeTimer != null: return
	challengeTimer = Timer.new()
	challengeTimer.wait_time = tipWaitTime
	challengeTimer.one_shot = true
	challengeTimer.connect("timeout", Callable(self, "onChallengeTimeout"))
	add_child(challengeTimer)
	challengeTimer.start()

func onChallengeTimeout():
	var tipInstance = tipUI.instantiate()
	if questVariables.get("learned_loop"):
		tipInstance.setTipText(tipText2)
	else:
		tipInstance.setTipText(tipText)
	add_child(tipInstance)

func moveNpc(pos: Vector2, speed: float = 4.0) -> void:
	if npc.position.x > pos.x: return
	if npc.position != pos and not npc.moving:
		QuestManager.moveNpcTo(npc.get_meta("objectName"), pos, speed)

func onUpdateQuestVariables():
	if questVariables.get("initialTalk"):
		npc.set("startingDialog", "8")
		spellManager.allowedToCast = true
		spellManager.learn_rune("fogo")
		spellEditor.allowedToUseEditor = true
		startChallenges()
	if questVariables.get("destroyedRock1"):
		npc.set("startingDialog", "12")
		moveNpc(Vector2(2532, -141), 2.0)
		if challengeTimer != null:
			challengeTimer.queue_free()
			challengeTimer = null
	if questVariables.get("initialLoop"):
		spellManager.learn_rune("for")
		spellManager.learn_rune("forend")
	if questVariables.get("learned_loop"):
		npc.set("startingDialog", "16")
		startChallenges()
	if questVariables.get("destroyedRock2"):
		npc.set("startingDialog", "20")
		moveNpc(Vector2(4527, -109), 2.0)
		if challengeTimer != null:
			challengeTimer.queue_free()
			challengeTimer = null
	if questVariables.get("destroyedRock3"):
		npc.set("startingDialog", "22")
		moveNpc(Vector2(6524, -141), 2.0)

func onRockDestroyed(node: Node2D) -> void:
	if node == rock1:
		QuestManager.setQuestVar("destroyedRock1", true)
	elif node == rock2:
		QuestManager.setQuestVar("destroyedRock2", true)
	elif node == rock3:
		QuestManager.setQuestVar("destroyedRock3", true)

func _ready():
	QuestManager.currentQuest = self
	QuestManager.connect("questVariablesChanged", Callable(self, "onUpdateQuestVariables"))
	rock1.connect("destroyed", Callable(self, "onRockDestroyed"))
	rock2.connect("destroyed", Callable(self, "onRockDestroyed"))
	rock3.connect("destroyed", Callable(self, "onRockDestroyed"))