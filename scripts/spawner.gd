extends Node2D

#==================================================================================================#
# State Variables

var spawn_timer: float = 5.0
var spawn_interval: float = 6.0
var interval_change: float = 0.99

#==================================================================================================#
# Config

const SPAWN_DISTANCE: float = 2000.0

#==================================================================================================#
# Nodes

@export var enemy_scene: PackedScene

#==================================================================================================#
# Main Behaviors

func _process(delta: float) -> void:
	if not GlobalState.game_started:
		return
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_enemy()
		spawn_timer = 0.0

func spawn_enemy() -> void:
	spawn_interval *= interval_change
	var spawn_point = get_spawn_point()
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_point
	get_tree().current_scene.add_child(enemy)

func get_spawn_point() -> Vector2:
	var random_angle = randf_range(0, 2 * PI)
	return global_position + Vector2(cos(random_angle) * SPAWN_DISTANCE, sin(random_angle) * SPAWN_DISTANCE)
