extends StaticBody2D

signal valuesChanged

@export var VAR_VALORES: Array = [0,0,0,0]
@export var SENHA: Array = [5,2,3,4]

@export var editableVars: Array = ["VAR_VALORES"]

@export var cogs: Array[Node2D] = []

@export var door: Sprite2D
@export var doorOpenTexture: Texture2D

var solved: bool = false

func _process(_delta: float) -> void:
	pass

func _ready() -> void:
	randomNumbers()

func randomNumbers() -> void:
	for i in range(VAR_VALORES.size()):
		VAR_VALORES[i] = Utils.randomNumbers(1, 0, 9)[0]
		set_index(i, VAR_VALORES[i])

func electrocute() -> void:
	if solved: return
	for cog in cogs:
		if cog.get("spinning") == true:
			return

	for i in range(cogs.size()):
		var cog = cogs[i]
		if cog and cog.has_method("spin"):
			cog.spin(VAR_VALORES[i])
	
	if VAR_VALORES == SENHA:
		var wait_time = VAR_VALORES.max()
		await get_tree().create_timer(wait_time).timeout
		if door and doorOpenTexture:
			door.texture = doorOpenTexture
			var collider: StaticBody2D = door.get_node("StaticBody2D")
			collider.queue_free()
		solved = true
		QuestManager.setQuestVar("opened", true)

func set_index(index: int, value: int) -> void:
	if index >= 0 and index < VAR_VALORES.size():
		VAR_VALORES[index] = value
		valuesChanged.emit()
		cogs[index].setup(VAR_VALORES[index])
	else:
		print("Índice fora dos limites: ", index)
	pass

func get_size() -> int:
	return VAR_VALORES.size()
