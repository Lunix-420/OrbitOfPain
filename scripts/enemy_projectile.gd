extends Area2D

#==================================================================================================#
# Nodes

@onready var sfx: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

#==================================================================================================#
# State Variables

var init_speed = 0
@export var damage: int

#==================================================================================================#
# Config

var speed := 1000
const GAIN = 6.0

#==================================================================================================#
# Main Behaviors

func set_speed(_speed: float):
	speed = _speed
	
func _ready() -> void:
	var sfx_clone = sfx.duplicate()
	sfx_clone.volume_db = GlobalState.sfx_volume + GAIN
	get_parent().add_child(sfx_clone)
	sfx_clone.global_position = global_position
	sfx_clone.play()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * (speed + init_speed) * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("loose_health"):
		body.loose_health(damage)
	queue_free()
