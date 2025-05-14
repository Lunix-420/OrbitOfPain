extends CharacterBody2D

var player: CharacterBody2D

func _ready():
	player = get_node("../Player")
	

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 20000.0 * delta
	rotation = direction.angle() + PI / 2
	move_and_slide()
