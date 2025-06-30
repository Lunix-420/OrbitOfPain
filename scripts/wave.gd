extends CharacterBody2D

signal died

#==================================================================================================#
# State Machine

enum State { IDLE, BREAK }
var state: State = State.IDLE

var state_timer: float = 0.0
var direction: float = 1.0  # 1 = clockwise, -1 = counter-clockwise
var is_dead: bool = false
var kill_timer: float = 0.0

#==================================================================================================#
# Config

const IDLE_DURATION: float = 3.0
const BREAK_DURATION: float = 1.0
const PROJECTILE_COUNT: int = 16
const PROJECTILE_SPEED: float = 500.0
const ROTATION_SPEED: float = 2.0
const BASE_SCORE: int = 2
const MAX_KILL_TIME: float = 15.0

#==================================================================================================#
# Audio Config

const EXPLOSION_GAIN: float = 0.0

#==================================================================================================#
# Nodes

@onready var explosion: GPUParticles2D = get_node("Explosion")
@export var energy_scene: PackedScene
@export var projectile_scene: PackedScene

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	_set_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if not GlobalState.game_started or is_dead:
		return

	kill_timer += delta
	state_timer += delta

	match state:
		State.IDLE:
			rotation += ROTATION_SPEED * delta * direction
			if state_timer >= IDLE_DURATION:
				_set_state(State.BREAK)
		State.BREAK:
			if state_timer >= BREAK_DURATION:
				_set_state(State.IDLE)

func _set_state(new_state: State) -> void:
	state = new_state
	state_timer = 0.0

	match new_state:
		State.BREAK:
			_fire_wave(PROJECTILE_COUNT / 2)
		State.IDLE:
			direction *= -1
			_fire_wave(PROJECTILE_COUNT)

func _fire_wave(_amount: int) -> void:
	for i in _amount:
		var angle = i * TAU / _amount
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		projectile.rotation = angle
		projectile.set_speed(PROJECTILE_SPEED)
		get_tree().current_scene.add_child(projectile)

#==================================================================================================#
# Health & Death

func take_damage() -> void:
	if is_dead:
		return
	is_dead = true
	GlobalState.increase_score(BASE_SCORE, kill_timer, MAX_KILL_TIME)
	_explode()
	spawn_energy()
	emit_signal("died")
	queue_free()

func _explode() -> void:
	var explosion_clone = explosion.duplicate()
	explosion_clone.emitting = true
	var sfx_clone = explosion_clone.get_node("Sfx")
	sfx_clone.volume_db = GlobalState.sfx_volume + EXPLOSION_GAIN
	get_parent().add_child(explosion_clone)
	explosion_clone.global_position = global_position
	sfx_clone.play()

func spawn_energy() -> void:
	var energy = energy_scene.instantiate()
	energy.position = global_position
	get_tree().current_scene.add_child(energy)
