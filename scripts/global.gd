extends Node

#==================================================================================================#
# State Variables

var game_started := false
var sfx_volume := -12.0
var music_volume := -12.0

#==================================================================================================#
# Global Reload

# We need to do this from global scope here, else the game crashes the second time we try
func reload_scene_after_delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	get_tree().reload_current_scene()
