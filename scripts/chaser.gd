extends CharacterBody2D

signal died

#==================================================================================================#
# State Variables
 
var is_dead: bool = false
var shoot_timer: float = -10.0
var player: CharacterBody2D
var kill_timer := 0.0

#==================================================================================================#
# Config

const SPEED = 10000.0
const ATTACK_TIMEOUT = 2.0
const BASE_SCORE = 1
const MAX_KILL_TIME = 15 # Max time to get score multiplier on kill

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
	player = get_node("../Player")
	shoot_timer = randf_range(-ATTACK_TIMEOUT, -ATTACK_TIMEOUT * 0.5)

func _physics_process(delta: float) -> void:
	if not GlobalState.game_started or is_dead:
		return
	kill_timer += delta
	_process_movement_and_attack(delta)
	move_and_slide()

func _process_movement_and_attack(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED * delta
	rotation = direction.angle() + PI / 2
	_process_shooting(delta)

#==================================================================================================#
# Weapons

func _process_shooting(delta: float) -> void:
	shoot_timer += delta
	if shoot_timer >= ATTACK_TIMEOUT:
		var projectile = projectile_scene.instantiate()
		projectile.rotation = rotation
		projectile.position = global_position
		projectile.set_speed(700)
		get_tree().current_scene.add_child(projectile)
		shoot_timer = randf_range(0, ATTACK_TIMEOUT * 0.2)

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
