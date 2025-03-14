extends Node

@onready var interactionManager: Node = get_node("../InteractionManager")

var npc = null
var dialog = null

signal end_dialog()

func setName():
	if npc == null: return
	var nameLabel = Label.new()
	nameLabel.name = "Name"
	nameLabel.text = npc.get_meta("objectName")
	npc.get_node("Dialog").add_child(nameLabel)


func setText(text):
	if npc == null: return
	var dialogText: Label = Label.new()
	dialogText.name = "Bubble"
	dialogText.text = text
	dialogText.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	npc.get_node("Dialog").add_child(dialogText)

func clearDialog():
	if npc == null: return
	var dialogNode = npc.get_node("Dialog")
	for child in dialogNode.get_children():
		child.queue_free()

func nextDialog(option):
	# example option: {"text": "I will check it out.", "next": null, "toggle": "talked" }
	if npc == null: return
	clearDialog()
	
	if option.has("toggle"):
		QuestManager.toggleQuestVar(option.toggle)

	if option.next == null:
		endDialog()
		return
	setName()
	setText(npc.dialog[option.next]["text"])
	if dialog[option.next].has("options"):
		createOptions(npc.dialog[option.next]["options"])

func createOptions(options):
	if npc == null: return
	var optionsContainer: VBoxContainer = VBoxContainer.new()
	optionsContainer.name = "OptionsContainer"
	npc.get_node("Dialog").add_child(optionsContainer)

	for i in range(options.size()):
		var option = options[i]
		var optionButton = Button.new()
		optionButton.text = option["text"]
		optionButton.connect("pressed", Callable(self, "nextDialog").bind(option))
		optionsContainer.add_child(optionButton)
	
	if options.size() == 0:
		var option = {"text": "[End]", "next": null}
		var optionButton = Button.new()
		optionButton.text = option["text"]
		optionButton.connect("pressed", Callable(self, "nextDialog").bind(option["next"]))
		optionsContainer.add_child(optionButton)

	
func startDialog(npcRef, dialogRef):
	npc = npcRef
	dialog = dialogRef
	var starterDialog = npc.dialog.get(npc.get("startingDialog"))
	nextDialog({"next": starterDialog.id, "options": starterDialog.options})
	# start npc quest if it has one
	if (npc.get("quest")) != null and QuestManager.currentQuest == null:
		QuestManager.currentQuest = npc.quest


func endDialog():
	emit_signal("end_dialog")
	npc = null

func _ready():
	interactionManager.connect("start_dialog", Callable(self, "startDialog"))
