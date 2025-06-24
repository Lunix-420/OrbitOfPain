extends Node2D

#==================================================================================================#

#Nodes
@onready var player: Node2D = get_parent()
@onready var camera: Camera2D = player.get_node("Camera") 
@onready var canvas: CanvasLayer = camera.get_node("CanvasLayer")

#Scenes
@export var enemy_scene: PackedScene
@export var fast_enemy_scene: PackedScene

#Enemy List
var current_enemies := []

#==================================================================================================#
# Configs

const SPAWN_DISTANCE := 2000.0

# Hardcoded Waves
@onready var waves := [
	{
		"subwaves": [
			{
				"spawn_delay": 0.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 1 }
				]
			},
			{
				"spawn_delay": 10.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 2 }
				]
			},
			{
				"spawn_delay": 10.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 3 }
				]
			}
		]
	},
	{
		"subwaves": [
			{
				"spawn_delay": 0.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 5 }
				]
			},
			{
				"spawn_delay": 15.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 6 }
				]
			},
			{
				"spawn_delay": 20.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 7 }
				]
			}
		]
	},
	{
		"subwaves": [
			{
				"spawn_delay": 0.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 10 }
				]
			},
			{
				"spawn_delay": 20.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 15 }
				]
			},
			{
				"spawn_delay": 30.0,
				"enemies": [
					{ "scene": enemy_scene, "count": 30 }
				]
			}
		]
	}
]

@export var endless_enemy_scenes: Dictionary = {
	"Enemy": {
		"scene":enemy_scene,
		"interval": 3.0,
		"timer": 0.0
	},
	"FastEnemy": {
		"scene": fast_enemy_scene,
		"interval": 5.0,
		"timer": 0.0
	}
}

#==================================================================================================#
# State Machine

enum GameState { BREAK, WAVE, ENDLESS }
var state := GameState.BREAK
var current_wave := 0
var subwave_index := 0
var subwave_timer := 0.0
var post_wave_delay := 3.0
var post_wave_timer := 0.0

#==================================================================================================#
# Process

func _process(delta: float) -> void:
	if not GlobalState.game_started:
		return

	match state:
		GameState.BREAK:
			if Input.is_action_just_pressed("action_start_next_wave"):
				start_next_wave()
		GameState.WAVE:
			_update_wave(delta)
		GameState.ENDLESS:
			_update_endless(delta)

func _on_enter_break() -> void:
	print("Entered Break State")
	canvas.on_enter_break()

func _on_enter_wave() -> void:
	print("Entered Wave State")
	canvas.on_enter_wave()

func _on_enter_endless() -> void:
	print("Entered Endless Mode")
	canvas.on_enter_endless()

#==================================================================================================#
# Wave System

func start_next_wave() -> void:
	if current_wave >= waves.size():
		_enter_endless()
		return

	print("Wave", current_wave + 1, "starting!")
	state = GameState.WAVE
	subwave_index = 0
	subwave_timer = 0.0
	_on_enter_wave()

func _update_wave(delta: float) -> void:
	var wave = waves[current_wave]
	var subwaves = wave["subwaves"]

	if subwave_index < subwaves.size():
		var current_subwave = subwaves[subwave_index]
		subwave_timer += delta

		if subwave_timer >= current_subwave["spawn_delay"]:
			_spawn_subwave(current_subwave)
			subwave_index += 1
			subwave_timer = 0.0
	else:
		# Only proceed to break if all enemies are deadb
		if current_enemies.is_empty():
			post_wave_timer += delta
			if post_wave_timer >= post_wave_delay:
				post_wave_timer = 0.0
				current_wave += 1
				state = GameState.BREAK
				print("Wave complete! Entering break.")
				GlobalState.skillpoints += 1
				_on_enter_break()

func _spawn_subwave(subwave: Dictionary) -> void:
	for enemy_data in subwave["enemies"]:
		for i in enemy_data["count"]:
			_spawn_enemy(enemy_data["scene"])

func _spawn_enemy(scene: PackedScene) -> void:
	var spawn_point = _get_spawn_point()
	var enemy = scene.instantiate()
	enemy.position = spawn_point
	get_tree().current_scene.add_child(enemy)
	
	# Track enemy and connect to its removal
	current_enemies.append(enemy)
	enemy.connect("died", Callable(self, "_on_enemy_removed").bind(enemy))

func _on_enemy_removed(enemy):
	if enemy in current_enemies:
		current_enemies.erase(enemy)

func _get_spawn_point() -> Vector2:
	var angle = randf_range(0, TAU)
	return global_position + Vector2(cos(angle), sin(angle)) * SPAWN_DISTANCE

#==================================================================================================#
# Endless Mode

func _enter_endless() -> void:
	state = GameState.ENDLESS
	print("Entering Endless Mode!")
	_on_enter_endless()

func _update_endless(delta: float) -> void:
	for key in endless_enemy_scenes.keys():
		var entry = endless_enemy_scenes[key]
		entry["timer"] += delta
		if entry["timer"] >= entry["interval"]:
			_spawn_enemy(entry["scene"])
			entry["timer"] = 0.0
