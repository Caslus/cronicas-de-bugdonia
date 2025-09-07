extends Control

@export var editor: PanelContainer
@export var openEditorButton: Button
@export var closeEditorButton: Button

@export var spellManager: SpellManager

@export var spellBlockContainer: PackedScene
@export var spellBlockList: HBoxContainer
@export var availableSpellBlockList: HBoxContainer

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
	for i in range(len(spellManager.availableSpellBlocks)):
		var block = spellManager.availableSpellBlocks[i]
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
	spellManager.run_current_spell()

func _ready() -> void:
	_updateAvailableSpellBlocks()
	_updateSpellBlocks()
