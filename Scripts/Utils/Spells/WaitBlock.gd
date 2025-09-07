extends SpellBlock
class_name WaitBlock

var config = {
		tempo = 1.0
}

func _init(_duration: float):
		shortName = "Tempo"
		name = "Runa de espera"
		description = "Esta runa faz o feitiço esperar um tempo determinado."
		icon = preload("res://Assets/UI/Spells/Time.png")
		config.tempo = _duration

func execute(context: Node) -> void:
		print("Waiting for %s seconds..." % config.tempo)
		await context.get_tree().create_timer(config.tempo).timeout
		print("Wait completed")
