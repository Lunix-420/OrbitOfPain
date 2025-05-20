extends AudioStreamPlayer2D

#==================================================================================================#
# Main Behaviors

func _on_finished() -> void:
	queue_free()
