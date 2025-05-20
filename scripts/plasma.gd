extends Area2D

#==================================================================================================#
# State Variables

var init_speed: float = 0

#==================================================================================================#
# Config

const SPEED: float = 1000.0
const GAIN: float = 6.0

#==================================================================================================#
# Nodes

@onready var sfx: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	var sfx_clone = sfx.duplicate()
	sfx_clone.volume_db = GlobalState.sfx_volume + GAIN
	get_parent().add_child(sfx_clone)
	sfx_clone.global_position = global_position
	sfx_clone.play()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * (SPEED + init_speed) * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
