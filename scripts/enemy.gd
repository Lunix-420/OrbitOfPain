extends CharacterBody2D

var player: CharacterBody2D

var shoot_timer: float = -5.0

func _ready():
	player = get_node("../Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 10000.0 * delta
	rotation = direction.angle() + PI / 2
	handle_shooting(delta)
	move_and_slide()
	
func handle_shooting(delta: float):
	shoot_timer += delta
	if shoot_timer >= 1.0:
		var laser = preload("res://scenes/Laser.tscn").instantiate()
		laser.rotation = rotation
		laser.position = global_position
		#laser.set("init_speed", speed)
		get_tree().current_scene.add_child(laser)
		shoot_timer = 0.0

func take_damage() -> void:
	spawn_energy()
	queue_free()

func spawn_energy() -> void:
	var energy = preload("res://scenes/Energy.tscn").instantiate()
	energy.position = global_position
	get_tree().current_scene.add_child(energy)
