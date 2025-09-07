extends Node
class_name SpellManager

@export var spellBlockLimit: int = 10

var availableSpellBlocks = [
	WaitBlock.new(1.0),
	FireballBlock.new(),
	ForStartBlock.new(2),
	ForEndBlock.new()
]

var currentSpell := Spell.new()

func _ready() -> void:
	pass

func get_current_spell() -> Spell:
	return currentSpell

func set_spell_blocks(blocks: Array[SpellBlock]) -> void:
	if blocks.size() > spellBlockLimit:
		blocks = blocks.slice(0, spellBlockLimit)
	currentSpell.blocks = blocks

func append_spell_block(block: SpellBlock) -> void:
	if currentSpell.blocks.size() < spellBlockLimit:
		currentSpell.blocks.append(block)

func pop_spell_block() -> void:
	if currentSpell.blocks.size() > 0:
		currentSpell.blocks.pop_back()

func remove_spell_block(index: int) -> void:
	if index >= 0 and index < currentSpell.blocks.size():
		currentSpell.blocks.remove_at(index)

func set_spell_block_config(index: int, config: Dictionary) -> void:
	if index >= 0 and index < currentSpell.blocks.size():
		currentSpell.blocks[index].config = config

func run_current_spell() -> void:
	if currentSpell.blocks.size() > 0:
		currentSpell.run(self)
