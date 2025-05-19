extends Area2D

@onready var sfx: AudioStreamPlayer2D = get_node("AudioStreamPlayer2D")
var init_speed = 0

const SPEED = 1000.0
const GAIN = 12.0

func _ready() -> void:
	sfx.volume_db = GlobalState.sfx_volume + GAIN
	sfx.play()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation - PI / 2)
	position += direction * (SPEED + init_speed) * delta


func _on_body_entered(body: Node2D) -> void:
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
