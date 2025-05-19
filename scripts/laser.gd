extends Area2D

@onready var sfx: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
var init_speed = 0

const SPEED = 1000.0
const GAIN = 12.0

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
	if body.has_method("loose_health"):
		body.loose_health()
	queue_free()
