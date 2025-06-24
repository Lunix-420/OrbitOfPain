extends Area2D

#==================================================================================================#
# State Variables

var init_speed: float = 0

#==================================================================================================#
# Config

const SPEED: float = 2000.0
const GAIN: float = 6.0
const TELEPORT_DISTANCE: float = 800

#==================================================================================================#
# Nodes

@onready var sfx: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
var player: Node2D = null

#==================================================================================================#
# Main Behaviors

func init(_player: Node2D, _direction: Vector2):
	player = _player

func _ready() -> void:
	var sfx_clone = sfx.duplicate()
	sfx_clone.volume_db = GlobalState.sfx_volume + GAIN
	get_parent().add_child(sfx_clone)
	sfx_clone.global_position = global_position
	sfx_clone.play()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * (SPEED + init_speed) * delta
	var distance = position.distance_to(player.position)
	if distance > TELEPORT_DISTANCE:
		_trigger()
	
func _on_body_entered(_body: Node2D) -> void:
	_trigger()

func _trigger() -> void:
	player.end_teleport(position)
	queue_free()
	
