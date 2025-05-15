extends Area2D

const SPEED = 1000.0

var init_speed = 0

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * (SPEED + init_speed) * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("loose_health"):
		body.loose_health()
