extends Resource
class_name Spell

var blocks: Array[SpellBlock] = []

func run(context: Node) -> Array:
		var runner = SpellRunner.new(blocks, context)
		print("Starting spell:")
		for i in range(blocks.size()):
				print("%d -> %s (%s)" % [i+1, blocks[i].shortName, blocks[i].config if blocks[i].config else ""])
		return runner.start()
