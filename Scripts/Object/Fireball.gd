extends Node2D

@export var speed: float = 400.0
@export var lifetime: float = 2.0
@export var explodeParticles: PackedScene
var velocity: Vector2 = Vector2.ZERO
var time_alive: float = 0.0

func spawn_explosion() -> void:
		var particles = explodeParticles.instantiate()
		particles.position = position
		get_tree().root.add_child(particles)
		particles.emitting = true
		await get_tree().create_timer(particles.lifetime).timeout
		particles.queue_free()

func despawn() -> void:
		queue_free()

func _process(delta):
		position += velocity * delta
		time_alive += delta
		if time_alive > lifetime:
			spawn_explosion()
			despawn()

func _on_body_entered(body: Node) -> void:
		if body.is_in_group("player"): return
		if body.is_in_group("destructible"):
			if body.get_parent().has_method("take_damage"):
				body.get_parent().take_damage(10)
		spawn_explosion()
		despawn()