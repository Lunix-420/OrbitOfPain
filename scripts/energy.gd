extends Area2D

#==================================================================================================#
# Main Behaviors

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("collect_energy"):
		body.collect_energy()
	queue_free()
