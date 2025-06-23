extends Node

#==================================================================================================#
# State Variables

var game_started := false

var sfx_volume := -12.0
var music_volume := -12.0

var highscore := 0
var skillpoints := 2

var perks := {
	"health" = false,		# Done
	"shield" = false,
	"teleport" = false,		# Done
	"battery" = false,		# Done
	"magnet" = false,
	"rocket" = false,
	"healing" = false,		# Done
	"speed" = false			# Done
}

#==================================================================================================#
# Global Reload
func reset() -> void:
	GlobalState.perks["health"] = true
	GlobalState.perks["shield"] = true
	GlobalState.perks["teleport"] = true
	GlobalState.perks["battery"] = true
	GlobalState.perks["magnet"] = true
	GlobalState.perks["rocket"] = true
	GlobalState.perks["dash"] = true
	GlobalState.perks["speed"] = true
	GlobalState.perks["health"] = true
	GlobalState.skillpoints = 0
	GlobalState.highscore = 0
	
# We need to do this from global scope here, else the game crashes the second time we try
func reload_scene_after_delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	get_tree().reload_current_scene()
