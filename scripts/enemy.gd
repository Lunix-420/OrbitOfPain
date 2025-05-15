extends CharacterBody2D

var player: CharacterBody2D

func _ready():
	player = get_node("../Player")

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 20000.0 * delta
	rotation = direction.angle() + PI / 2
	move_and_slide()
	
func take_damage() -> void:
	spawn_energy()
	queue_free()

func spawn_energy() -> void:
	var energy = preload("res://scenes/Energy.tscn").instantiate()
	energy.position = global_position
	get_tree().current_scene.add_child(energy)
