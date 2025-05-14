extends Area2D

const SPEED = 1000.0

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * SPEED * delta
