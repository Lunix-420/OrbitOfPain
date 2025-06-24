extends Node

#==================================================================================================#
# State Variables

var game_started := false

var sfx_volume := -12.0
var music_volume := -12.0

#==================================================================================================#
# Perks

var skillpoints := 0

var perks := {
	"health" = false,		# Done
	"shield" = false,		# Done
	"teleport" = false,		# Done
	"battery" = false,		# Done 
	"magnet" = false,		# Done
	"rocket" = false,		
	"healing" = false,		# Done
	"speed" = false			# Done
}

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

#==================================================================================================#
# Global Reload
	
# We need to do this from global scope here, else the game crashes the second time we try
func reload_scene_after_delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	get_tree().reload_current_scene()
	
#==================================================================================================#
# Highscore

var seconds_since_last_hit: float = 0.0
var seconds_since_last_move: float = 0.0
var combo_count: int = 0
var highscore := 0

const MOVE_MULTIPLIER_CAP = 5.0
const COMBO_MULTIPLIER_STEP = 0.1
const COMBO_MULTIPLIER_CAP = 10.0

func _process(delta):
	seconds_since_last_hit += delta
	seconds_since_last_move += delta

func player_hit(): # Done
	seconds_since_last_hit = 0.0

func player_moved(): # Done
	seconds_since_last_move = 0.0

func shot_missed(): 
	combo_count = 0	

func register_kill(): # Done
	combo_count += 1

func get_hit_multiplier() -> float:
	return max(1.0, seconds_since_last_hit)

func get_move_multiplier() -> float:
	return clamp(seconds_since_last_move, 1.0, MOVE_MULTIPLIER_CAP)

func get_combo_multiplier() -> float:
	return 1.0 + min(combo_count * COMBO_MULTIPLIER_STEP, COMBO_MULTIPLIER_CAP)

func get_total_multiplier() -> float:
	return get_hit_multiplier() * get_move_multiplier() * get_combo_multiplier()

func increase_score(base_score: int, kill_timer: float, max_kill_time: float) -> int:
	var quarter_time = max_kill_time / 4.0
	var speed_multiplier = 1.0

	if kill_timer <= quarter_time:
		speed_multiplier = 10.0
	elif kill_timer <= max_kill_time:
		var t = (kill_timer - quarter_time) / (max_kill_time - quarter_time)
		speed_multiplier = lerp(10.0, 1.0, t)
	else:
		speed_multiplier = 1.0

	var total_multiplier = speed_multiplier * get_hit_multiplier() * get_move_multiplier() * get_combo_multiplier()

	var score_gain = int(base_score * total_multiplier)

	# Update global score and combo
	highscore += score_gain
	register_kill()

	return score_gain
