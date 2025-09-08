extends Node2D

@export var maxHealth: float = 100.0
@export var objectName: String = "Pedra"
var health: float
@export var breakParticles: PackedScene
@onready var healthBar: Control = get_node("HealthBar")

func take_damage(amount: float) -> void:
		health -= amount
		healthBar.setHealth(health)

		if health <= 0:
				break_obstacle()

func break_particle() -> void:
		var particles = breakParticles.instantiate()
		particles.position = position
		particles.scale = Vector2(2, 2)
		get_tree().root.add_child(particles)
		particles.emitting = true
		await get_tree().create_timer(particles.lifetime).timeout
		particles.queue_free()

func break_obstacle() -> void:
		break_particle()
		queue_free()

func _ready() -> void:
	health = maxHealth
	healthBar.setup(maxHealth, objectName)
