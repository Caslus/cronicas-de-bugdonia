extends Sprite2D

@export var grid: GridContainer
@export var dragonParticles: PackedScene
@export var endMessage: PackedScene
@export var quest: Node
@onready var gridColumns: int = grid.get("gridColumns")
@onready var gridRows: int = grid.get("cellCount") / gridColumns
@onready var cellSize: int = grid.get("cellSize")

@onready var healthBar: ProgressBar = get_node("HealthBar").get_node("CanvasLayer").get_node("Control").get_node("ProgressBar")

@export var moveTime: float = 0.5
@export var waitTime: float = 4.0

var originalPosition: Vector2
var currentCell: Vector2 = Vector2(0, 0)
enum State { FLY_RIGHT, FLY_DOWN, FLY_LEFT, FLY_CENTER, FLY_UP, DEAD }
var state: State = State.FLY_RIGHT
var moving: bool = false

var health: int = 100

func setState(newState: State) -> void:
		if state == State.DEAD: return
		state = newState

func fly_right() -> void:
		moving = true
		self.scale = Vector2(2, 2)
		var targetX = position.x + cellSize * (gridColumns - 1)
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(self, "position:x", targetX, moveTime)
		await tween.finished
		currentCell = Vector2(gridColumns - 1, currentCell.y)
		await get_tree().create_timer(waitTime).timeout
		setState(State.FLY_DOWN)
		moving = false

func fly_down() -> void:
		moving = true
		var targetY = position.y + cellSize * (gridRows - 1)
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(self, "position:y", targetY, moveTime)
		await tween.finished
		currentCell = Vector2(currentCell.x, gridRows - 1)
		await get_tree().create_timer(waitTime).timeout
		setState(State.FLY_LEFT)
		moving = false

func fly_left() -> void:
		moving = true
		self.scale = Vector2(-2, 2)
		var targetX = originalPosition.x
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(self, "position:x", targetX, moveTime)
		await tween.finished
		currentCell = Vector2(0, currentCell.y)
		await get_tree().create_timer(waitTime).timeout
		setState(State.FLY_CENTER)
		moving = false

func fly_center() -> void:
		moving = true
		self.scale = Vector2(2, 2)
		var targetPosition = originalPosition + Vector2((gridColumns - 1) * cellSize / 2, (gridRows - 1) * cellSize / 2)
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(self, "position", targetPosition, moveTime)
		await tween.finished
		currentCell = Vector2((gridColumns - 1) / 2, (gridRows - 1) / 2)
		await get_tree().create_timer(waitTime*1.5).timeout
		setState(State.FLY_UP)
		moving = false

func fly_up() -> void:
		moving = true
		self.scale = Vector2(-2, 2)
		var targetPosition = originalPosition
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(self, "position", targetPosition, moveTime)
		await tween.finished
		currentCell = Vector2(0, 0)
		await get_tree().create_timer(waitTime).timeout
		setState(State.FLY_RIGHT)
		moving = false

func chooseAction() -> void:
		if moving: return
		match state:
			State.FLY_RIGHT:
				fly_right()
			State.FLY_DOWN:
				fly_down()
			State.FLY_LEFT:
				fly_left()
			State.FLY_CENTER:
				fly_center()
			State.FLY_UP:
				fly_up()

func _ready() -> void:
		position = grid.position + Vector2(cellSize / 2, cellSize / 2)
		originalPosition = position
		currentCell = Vector2(0, 0)

func take_damage(damage: int) -> void:
		if state == State.DEAD: return
		health -= damage
		# tween health bar
		var tween = create_tween()
		tween.set_ease(Tween.EaseType.EASE_IN_OUT)
		tween.tween_property(healthBar, "value", health, 0.5)
		healthBar.get_node("AnimationPlayer").play("Hit")

		var tweenColor = create_tween()
		tweenColor.set_ease(Tween.EaseType.EASE_IN_OUT)
		tweenColor.tween_property(self, "modulate", Color(1, 0, 0), 0.1)
		tweenColor.tween_property(self, "modulate", Color(1, 1, 1), 0.4)

		if health <= 0:
			setState(State.DEAD)
			healthBar.get_parent().visible = false
			self.visible = false
			var particles = dragonParticles.instantiate()
			particles.position = position
			get_tree().root.add_child(particles)
			particles.get_node("GPUParticles2D").emitting = true
			QuestManager.setQuestVar("finished", true)

			var message = endMessage.instantiate()
			get_tree().root.add_child(message)
			await get_tree().create_timer(2.0).timeout
			particles.queue_free()
			await get_tree().create_timer(5.0).timeout
			message.queue_free()
			quest.set("questVariables", {"finished": true})


func _process(_delta: float) -> void:
		chooseAction()
