extends Button

func _on_pressed() -> void:
	var currentQuest = QuestManager.currentQuest
	if (!currentQuest):
		return
	if(currentQuest.get("nextQuest")):
		QuestManager.setCurrentQuest(currentQuest.get("nextQuest"))

func updateText() -> void:
	text = QuestManager.currentQuest.get("questName")

func _ready() -> void:
	QuestManager.connect("questChanged", Callable(self, "updateText"))
