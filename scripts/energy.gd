extends Area2D

#==================================================================================================#
# Nodes

@onready var world: Node2D = get_parent()
@onready var player: Node2D = world.get_node("Player")

#==================================================================================================#
# Parameters

const MAX_MAGNET_DISTANCE := 2000.0
const MAX_MAGNET_SPEED := 500.0

#==================================================================================================#
# Main Behaviors

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	if not GlobalState.perks["magnet"]:
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()

	if distance > MAX_MAGNET_DISTANCE:
		return  # too far, no attraction

	var attraction_strength := 1.0 - (distance / MAX_MAGNET_DISTANCE)
	var speed := MAX_MAGNET_SPEED * pow(attraction_strength, 2)  # quadratic curve

	var direction := to_player.normalized()
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_energy"):
		body.collect_energy()
	queue_free()
