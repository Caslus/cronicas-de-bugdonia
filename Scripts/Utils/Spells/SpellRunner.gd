extends Node
class_name SpellRunner

signal spell_failed

var blocks: Array
var context: Node

func _init(_blocks: Array, _context: Node) -> void:
	blocks = _blocks
	context = _context

func start() -> void:
	# validate syntax before running
	if not validate_syntax(blocks):
		emit_signal("spell_failed")
		return
	call_deferred("_run")

func _run() -> void:
	var i = 0
	while i < blocks.size():
		var block = blocks[i]

		if block is ForStartBlock:
			var end_index = find_matching_end(i)
			if end_index == -1:
				emit_signal("spell_failed")
				return

			for n in range(block.config.contagem):
				await run_block_range(i + 1, end_index)

			i = end_index  # jump to the matching ForEnd
		elif block is ForEndBlock:
			# shouldn't reach here directly if validation passed
			pass
		else:
			await block.execute(context)

		# small delay between instructions
		await context.get_tree().create_timer(0.1).timeout
		i += 1


func run_block_range(range_start: int, end: int) -> void:
	var j = range_start
	while j < end:
		var b = blocks[j]

		if b is ForStartBlock:
			var end_index = find_matching_end(j)
			if end_index == -1:
				emit_signal("spell_failed")
				return
			for n in range(b.config.contagem):
				await run_block_range(j + 1, end_index)
			j = end_index  # skip to the matching ForEnd
		elif b is ForEndBlock:
			# handled by find_matching_end, skip
			pass
		else:
			await b.execute(context)
			await context.get_tree().create_timer(0.1).timeout

		j += 1


func find_matching_end(start_index: int) -> int:
	var depth = 0
	for i in range(start_index + 1, blocks.size()):
		var b = blocks[i]
		if b is ForStartBlock:
			depth += 1
		elif b is ForEndBlock:
			if depth == 0:
				return i
			depth -= 1
	return -1


func validate_syntax(block_list: Array) -> bool:
	var depth = 0
	var stack: Array[int] = []  # track positions of ForStart

	for i in range(block_list.size()):
		var b = block_list[i]

		if b is ForStartBlock:
			depth += 1
			stack.append(i)

		elif b is ForEndBlock:
			if depth <= 0:
				print("Syntax error: ForEnd without ForStart at index %d" % i)
				return false

			var start_index = stack.pop_back()
			depth -= 1

			# check if this loop is empty
			if i == start_index + 1:
				print("Syntax error: Empty loop between %d and %d" % [start_index, i])
				return false

	if depth != 0:
		print("Syntax error: Unmatched ForStart")
		return false

	return true
