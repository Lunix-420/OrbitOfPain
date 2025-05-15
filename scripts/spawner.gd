extends Node2D

var spawn_timer: float = 0.0
var spawn_interval: float = 5.0
var SPAWN_DISTANCE: float = 2000.0

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy() -> void:
	var spawn_point = get_spawn_point()
	var enemy = preload("res://scenes/Enemy.tscn").instantiate()
	enemy.position = spawn_point
	get_tree().current_scene.add_child(enemy)

func get_spawn_point() -> Vector2:
	var random_angle = randf_range(0, 2 * PI)
	return global_position + Vector2(cos(random_angle) * SPAWN_DISTANCE, sin(random_angle) * SPAWN_DISTANCE)
