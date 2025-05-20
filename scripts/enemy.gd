extends CharacterBody2D

#==================================================================================================#
# State Variables
 
var is_dead: bool = false
var shoot_timer: float = -3.0
var player: CharacterBody2D

#==================================================================================================#
# Movement & Attack Config

const SPEED = 10000.0
const ATTACK_TIMEOUT = 1.5

#==================================================================================================#
# Audio Config

const EXPLOSION_GAIN: float = 0.0

#==================================================================================================#
# Nodes

@onready var explosion: GPUParticles2D = get_node("Explosion")

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	player = get_node("../Player")

func _physics_process(delta: float) -> void:
	if not GlobalState.game_started or is_dead:
		return
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
		var laser = preload("res://scenes/Laser.tscn").instantiate()
		laser.rotation = rotation
		laser.position = global_position
		get_tree().current_scene.add_child(laser)
		shoot_timer = 0.07

#==================================================================================================#
# Health & Death

func take_damage() -> void:
	if is_dead:
		return
	is_dead = true
	_explode()
	spawn_energy()
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
	var energy = preload("res://scenes/Energy.tscn").instantiate()
	energy.position = global_position
	get_tree().current_scene.add_child(energy)
