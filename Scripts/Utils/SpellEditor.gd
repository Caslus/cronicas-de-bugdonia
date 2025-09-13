extends Control

@export var allowedToUseEditor: bool = true

@export var editor: PanelContainer
@export var openEditorButton: Button
@export var closeEditorButton: Button

@export var spellManager: SpellManager

@export var spellBlockContainer: PackedScene
@export var spellBlockList: HBoxContainer
@export var availableSpellBlockList: HBoxContainer

@export var cooldownTime: float = 3.0
var can_cast: bool = true
@export var cooldownTimeBar: ProgressBar

func _openEditor() -> void:
	editor.visible = true
	openEditorButton.visible = false

func _closeEditor() -> void:
	editor.visible = false
	openEditorButton.visible = true

func _clearChildren(node: Node) -> void:
	var children = node.get_children()
	for child in children:
		child.queue_free()

func _updateSpellBlocks() -> void:
	_clearChildren(spellBlockList)
	for i in range(len(spellManager.get_current_spell().blocks)):
		var block = spellManager.get_current_spell().blocks[i]
		var blockInstance = spellBlockContainer.instantiate()
		blockInstance.set_config(block, i)
		blockInstance.set_action(func():
			spellManager.remove_spell_block(blockInstance.get_meta("index"))
			_updateSpellBlocks()
		)
		spellBlockList.add_child(blockInstance)
		if block.config.size() > 0:
			blockInstance.add_config_ui()
			blockInstance.connect("config_saved", Callable(self, "updateBlockConfig"))

func _updateAvailableSpellBlocks() -> void:
	_clearChildren(availableSpellBlockList)
	for i in range(len(spellManager.learnedRunes)):
		var block;
		for b in spellManager.availableSpellBlocks:
			if b.shortName.to_lower() == spellManager.learnedRunes[i]:
				block = b
				break
		if block == null:
			continue

		var blockInstance = spellBlockContainer.instantiate()
		blockInstance.set_config(block, i)
		blockInstance.set_action(func():
			spellManager.append_spell_block(block)
			_updateSpellBlocks()
		)
		availableSpellBlockList.add_child(blockInstance)

func updateBlockConfig(new_config: Dictionary, index: int) -> void:
	spellManager.set_spell_block_config(index, new_config)
	_updateSpellBlocks()

func _runSpell() -> void:
	if not can_cast:
		return
	can_cast = false
	spellManager.run_current_spell()
	get_tree().create_timer(cooldownTime).timeout.connect(func(): can_cast = true)
	cooldownTimeBar.value = 100
	cooldownTimeBar.visible = true
	var tween = create_tween()
	tween.tween_property(cooldownTimeBar, "value", 0, cooldownTime)

func _runeLearned(_rune_name: String) -> void:
	_updateAvailableSpellBlocks()

func _ready() -> void:
	_updateAvailableSpellBlocks()
	_updateSpellBlocks()

	spellManager.connect("rune_learned", Callable(self, "_runeLearned"))

func _process(_delta: float) -> void:
	if not allowedToUseEditor:
		get_node("CanvasLayer").visible = false
		return
	else:
		get_node("CanvasLayer").visible = true

	if Input.is_action_just_pressed("run_spell"):
		_runSpell()
	if Input.is_action_just_pressed("toggle_spell_editor"):
		if editor.visible:
			_closeEditor()
		else:
			_openEditor()
