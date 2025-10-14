extends Node
class_name SpellManager

signal rune_learned(rune_name: String)

@export var spellBlockLimit: int = 10
@export var failParticles: PackedScene
@export var allowedToCast: bool = true
@export var learnedRunes: Array[String] = []

var availableSpellBlocks = [
	WaitBlock.new(1.0),
	FireballBlock.new(),
	ForStartBlock.new(2),
	ForEndBlock.new(),
	EditIndexBlock.new(0, 0),
	LightningBlock.new(),
	ExplosionBlock.new(0, 0)
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
		var shortName = block.shortName.to_lower()
		match shortName:
			"for":
				currentSpell.blocks.append(ForStartBlock.new(block.config.contagem))
			"forend":
				currentSpell.blocks.append(ForEndBlock.new())
			"fogo":
				currentSpell.blocks.append(FireballBlock.new())
			"tempo":
				currentSpell.blocks.append(WaitBlock.new(block.config.tempo))
			"editarindice":
				currentSpell.blocks.append(EditIndexBlock.new(block.config.indice, block.config.valor))
			"raio":
				currentSpell.blocks.append(LightningBlock.new())
			"explosao":
				currentSpell.blocks.append(ExplosionBlock.new(block.config.coluna, block.config.linha))
			_:
				pass # unknown block, do nothing

func pop_spell_block() -> void:
	if currentSpell.blocks.size() > 0:
		currentSpell.blocks.pop_back()

func remove_spell_block(index: int) -> void:
	if index >= 0 and index < currentSpell.blocks.size():
		currentSpell.blocks.remove_at(index)

func set_spell_block_config(index: int, config: Dictionary) -> void:
	if index >= 0 and index < currentSpell.blocks.size():
		currentSpell.blocks[index].config = config

func run_current_spell() -> Array:
	if not allowedToCast:
		return [false, "Você não pode lançar feitiços agora."]

	if currentSpell.blocks.size() > 0:
		var result = currentSpell.run(self)
		if not result[0]:
			print("Erro ao executar feitiço: %s" % result[1])
			fail_spell()
		return result
	else:
		fail_spell()
		return [false, "Erro de sintaxe: Nenhum bloco de feitiço para executar."]

func fail_spell() -> void:
	var particles = failParticles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = get_parent().global_position
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	particles.queue_free()

func learn_rune(rune_name: String) -> void:
	var lower_name = rune_name.to_lower()
	if not learnedRunes.has(lower_name):
		learnedRunes.append(lower_name)
		emit_signal("rune_learned", lower_name)
