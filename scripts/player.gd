extends CharacterBody2D

#==================================================================================================#
# Enums

enum ExhaustDirection {
	Front,
	Back,
	Left,
	Right
}

#==================================================================================================#
# State Variables

var is_dead: bool = false
var forward_speed: float = 0.0
var strafe_speed: float = 0.0

#==================================================================================================#
# Movement Config

const MAX_FORWARD_SPEED = 500.0
const MAX_BACKWARD_SPEED = 500.0
const MAX_STRAFE_SPEED = 400.0
const FORWARD_ACCEL = 2000.0
const STRAFE_ACCEL = 4000.0
const ROTATE_SPEED = 4.0
const FRICTION = 500.0

#==================================================================================================#
# Energy & Health Config

const BASE_ENERGY_DRAIN = 20.0
const ENERGY_LOSS = 2000.0
const ENERGY_PICKUP_STRENGTH = 200
const WEAPON_COST = 40
const TELEPORT_COST = 50
const ENEMY_DAMAGE = 150.0
const HEALING_SPEED = 20.0
const SHIELD_COST = 250.0
const SHIELD_DAMAGE_MULTIPLIER = 0.5

#==================================================================================================#
# Audio Config

const ENERGY_AUDIO_GAIN_DB = 0.0
const EXHAUST_AUDIO_GAIN_DB = -3.0
const EXPLOSION_GAIN = 6.0
const DAMAGE_GAIN = 0.0

#==================================================================================================#
# Nodes 

@onready var collider = get_node("CollisionShape2D")
@onready var sprite = get_node("Sprite")
@onready var shooter = sprite.get_node("Shooter")
@onready var shield = get_node("Shield")
@onready var exhaust_back_left = sprite.get_node("ExhaustBackLeft")
@onready var exhaust_back_right = sprite.get_node("ExhaustBackRight")
@onready var exhaust_front_left = sprite.get_node("ExhaustFrontLeft")
@onready var exhaust_front_right = sprite.get_node("ExhaustFrontRight")
@onready var exhaust_side_left = sprite.get_node("ExhaustSideLeft")
@onready var exhaust_side_right = sprite.get_node("ExhaustSideRight")
@onready var camera: Camera2D = $Camera
@onready var gui: Control = camera.get_node("Gui")
@onready var health_bar: BaseBar = gui.get_node("Health")
@onready var energy_bar: BaseBar = gui.get_node("Energy")
@onready var energy_audio: AudioStreamPlayer2D = $EnergyAudioPlayer
@onready var exhaust_audio: AudioStreamPlayer2D = $ExhaustAudioPlayer
@onready var damage_audio: AudioStreamPlayer2D = $DamageAudioPlayer
@onready var explosion: GPUParticles2D = get_node("Explosion")
@export var plasma_scene: PackedScene
@export var teleporter_scene: PackedScene

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	exhaust_audio.volume_db = GlobalState.sfx_volume + EXHAUST_AUDIO_GAIN_DB
	damage_audio.volume_db = GlobalState.sfx_volume + DAMAGE_GAIN

func _physics_process(delta: float) -> void:
	if not GlobalState.game_started:
		return
	_process_movement(delta)
	_process_rotation(delta)
	_process_shooting()
	_process_teleport()
	_process_healing(delta)
	_process_shield(delta)
	consume_energy(BASE_ENERGY_DRAIN * delta)
	update_exhaust_audio()
	move_and_slide()

#==================================================================================================#
# Movement

func _process_movement(delta: float) -> void:
	var move_forward = int(Input.is_action_pressed("move_forward"))
	var move_backward =  int(Input.is_action_pressed("move_backwards"))
	var forward_input = move_forward - move_backward
	var move_left =  int(Input.is_action_pressed("move_left"))
	var move_right = int(Input.is_action_pressed("move_right"))
	var strafe_input = move_left - move_right
	var multiplier = 1.0
	if GlobalState.perks["speed"]:
		multiplier = 1.5
	var raw_forward_speed = forward_speed + FORWARD_ACCEL * forward_input * delta
	forward_speed = clamp(raw_forward_speed, -MAX_BACKWARD_SPEED, MAX_FORWARD_SPEED)
	var raw_strafe_speed = strafe_speed + STRAFE_ACCEL * strafe_input * delta
	strafe_speed = clamp(raw_strafe_speed, -MAX_STRAFE_SPEED, MAX_STRAFE_SPEED)
	if forward_input == 0:
		forward_speed = _apply_friction(forward_speed, delta)
	if strafe_input == 0:
		strafe_speed = _apply_friction(strafe_speed, delta)	
	var forward_dir = sprite.global_transform.y.normalized()
	var right_dir = sprite.global_transform.x.normalized()
	velocity = forward_dir * forward_speed * multiplier + right_dir * strafe_speed * multiplier
	_update_exhaust_emission(forward_input, strafe_input)

func _apply_friction(value: float, delta: float) -> float:
	if value > 0:
		return max(value - FRICTION * delta, 0)
	elif value < 0:
		return min(value + FRICTION * delta, 0)
	return 0.0

func _process_rotation(delta: float) -> void:
	if Input.is_action_pressed("move_turn_ccw"):
		sprite.rotation += ROTATE_SPEED * delta
	if Input.is_action_pressed("move_turn_cw"):
		sprite.rotation -= ROTATE_SPEED * delta

#==================================================================================================#
# Actions

func _process_shield(delta: float) -> void:
	if not GlobalState.perks["shield"]:
		shield.visible = false
		return
	if Input.is_action_pressed("action_shield"):
		consume_energy(SHIELD_COST * delta)
		shield.visible = true
	else:
		shield.visible = false

func _process_shooting() -> void:
	if Input.is_action_just_pressed("action_shoot"):
		consume_energy(WEAPON_COST)
		var plasma = plasma_scene.instantiate()
		var dir = -sprite.global_transform.x.normalized()
		plasma.rotation = dir.angle()
		plasma.position = shooter.global_position
		plasma.set("init_speed", forward_speed)
		get_tree().current_scene.add_child(plasma)
		
func _process_teleport() -> void:
	if not GlobalState.perks["teleport"]:
		return
		
	if not energy_bar.current_value > TELEPORT_COST:
		return

	if Input.is_action_just_pressed("action_teleport"):
		# Get inputs
		var move_forward = int(Input.is_action_pressed("move_forward"))
		var move_backward =  int(Input.is_action_pressed("move_backwards"))
		var forward_input = move_forward - move_backward
		var move_left =  int(Input.is_action_pressed("move_left"))
		var move_right = int(Input.is_action_pressed("move_right"))
		var strafe_input = move_left - move_right

		# Cancel out opposite inputs
		if Input.is_action_pressed("move_forward") and Input.is_action_pressed("move_backwards"):
			forward_input = 0
		if Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
			strafe_input = 0

		# Build direction vector using your sprite's axis convention
		var forward_dir = sprite.global_transform.x.normalized() * -forward_input
		var strafe_dir = sprite.global_transform.y.normalized() * strafe_input
		var dir = forward_dir + strafe_dir

		# Default direction if no input
		if dir == Vector2.ZERO:
			dir = sprite.global_transform.y.normalized()
		
		# Normalize to get direction
		dir = dir.normalized()
		
		# Drain energy and init teleport
		consume_energy(TELEPORT_COST)
		var teleporter = teleporter_scene.instantiate()
		teleporter.init(self, dir)
		teleporter.rotation = dir.angle()
		teleporter.position = shooter.global_position
		teleporter.set("init_speed", forward_speed)
		get_tree().current_scene.add_child(teleporter)
		_start_teleport()


func _start_teleport() -> void:
	sprite.visible = false
	collider.disabled = true

func end_teleport(teleport_position: Vector2) -> void:
	position = teleport_position
	sprite.visible = true
	collider.disabled = false

#==================================================================================================#
# Exhaust

func _update_exhaust_emission(forward_input: int, strafe_input: int) -> void:
	_set_exhaust_emission(ExhaustDirection.Front, forward_input < 0)
	_set_exhaust_emission(ExhaustDirection.Back, forward_input > 0)
	_set_exhaust_emission(ExhaustDirection.Left, strafe_input < 0)
	_set_exhaust_emission(ExhaustDirection.Right, strafe_input > 0)

func _set_exhaust_emission(direction: ExhaustDirection, state: bool) -> void:
	match direction:
		ExhaustDirection.Front:
			exhaust_front_left.emitting = state
			exhaust_front_right.emitting = state
		ExhaustDirection.Back:
			exhaust_back_left.emitting = state
			exhaust_back_right.emitting = state
		ExhaustDirection.Left:
			exhaust_side_left.emitting = state
		ExhaustDirection.Right:
			exhaust_side_right.emitting = state

func update_exhaust_audio() -> void:
	var is_emitting = exhaust_back_left.emitting or exhaust_back_right.emitting \
		or exhaust_front_left.emitting or exhaust_front_right.emitting \
		or exhaust_side_left.emitting or exhaust_side_right.emitting

	if is_emitting and not exhaust_audio.playing:
		exhaust_audio.play()
	elif not is_emitting and exhaust_audio.playing:
		exhaust_audio.stop()
	
#==================================================================================================#
# Health & Energy 

func _process_healing(delta: float) -> void:
	if not GlobalState.perks["healing"]:
		return
	var amount = HEALING_SPEED * delta
	gain_health(amount)

func loose_health() -> void:
	# Calculate Damage
	var multiplier = 1.0
	if (GlobalState.perks["health"]):
		multiplier = 1.0 / 3.0
	var damage = ENEMY_DAMAGE * multiplier
	
	# Reduce Health or Energy (if shield is active)
	if not shield.visible:
		health_bar.set_current_value(health_bar.current_value - damage)
	else:
		consume_energy(damage * SHIELD_DAMAGE_MULTIPLIER)
		
	if health_bar.current_value <= 0:
		death()
	else:
		damage_audio.play()
	
func gain_health(amount: float) -> void:
	health_bar.set_current_value(health_bar.current_value + amount)

func collect_energy() -> void:
	energy_bar.set_current_value(energy_bar.current_value + ENERGY_PICKUP_STRENGTH)
	energy_audio.volume_db = GlobalState.sfx_volume + ENERGY_AUDIO_GAIN_DB
	energy_audio.play()

func consume_energy(amount: float) -> void:
	var multiplier = 1.0
	if GlobalState.perks["battery"]:
		multiplier = 1.0 / 3.0
	var energy_loss = multiplier * amount
	energy_bar.set_current_value(energy_bar.current_value - energy_loss)
	if energy_bar.current_value <= 0:
		death()

func death() -> void:
	explode()
	GlobalState.game_started = false
	sprite.visible = false
	GlobalState.reload_scene_after_delay(2.0)

func explode() -> void:
	if not GlobalState.game_started:
		return
	var explosion_clone = explosion.duplicate()
	explosion_clone.emitting = true
	var sfx_clone = explosion_clone.get_node("Sfx")
	sfx_clone.volume_db = GlobalState.sfx_volume + EXPLOSION_GAIN
	get_parent().add_child(explosion_clone)
	explosion_clone.global_position = global_position
	sfx_clone.play()
