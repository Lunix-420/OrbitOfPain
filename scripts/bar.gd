extends Control
class_name BaseBar

#==================================================================================================#
# State Variables

@export var min_value: float
@export var max_value: float
@export var current_value: float

#==================================================================================================#
# Nodes

@export var top_bar: ProgressBar
@export var bottom_bar: ProgressBar

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	current_value = max_value
	_set_bar_defaults(top_bar)
	_set_bar_defaults(bottom_bar)

#==================================================================================================#
# Bar Logic

func _set_bar_defaults(bar: ProgressBar) -> void:
	bar.min_value = min_value
	bar.max_value = max_value
	bar.value = current_value

func set_current_value(value: float) -> void:
	current_value = clamp(value, min_value, max_value)
	_run_tween(top_bar, current_value, 0.2, 0)
	_run_tween(bottom_bar, current_value, 0.8, 0.2)

func _run_tween(bar: ProgressBar, value: float, length: float, delay: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", value, length).set_delay(delay)
