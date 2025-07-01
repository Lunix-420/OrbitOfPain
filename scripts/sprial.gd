extends CharacterBody2D

signal died

#==================================================================================================#
# State Variables

var is_dead: bool = false
var shoot_timer: float = 0.0
var kill_timer := 0.0

#==================================================================================================#
# Config

const ATTACK_TIMEOUT = 0.2  # shoot every 0.2 seconds
const ROTATION_SPEED = 3.0  # radians per second, tweak for spiral speed
const BASE_SCORE = 3
const MAX_KILL_TIME = 15

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
	shoot_timer = 0.0

func _physics_process(delta: float) -> void:
	if not GlobalState.game_started or is_dead:
		return

	kill_timer += delta
	_process_rotation(delta)
	_process_shooting(delta)

func _process_rotation(delta: float) -> void:
	rotation += ROTATION_SPEED * delta

func _process_shooting(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= ATTACK_TIMEOUT:
		shoot_timer -= ATTACK_TIMEOUT  # keep leftover delta for accuracy
		var projectile = projectile_scene.instantiate()
		projectile.rotation = rotation
		projectile.position = global_position
		projectile.set_speed(500)
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
