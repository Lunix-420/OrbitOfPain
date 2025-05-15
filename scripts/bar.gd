class_name BaseBar extends Control

@export var top_bar: ProgressBar
@export var bottom_bar: ProgressBar

@export var min_value: float
@export var max_value: float
@export var current_value: float

func _ready() -> void:
	current_value = max_value
	set_default_values(top_bar)
	set_default_values(bottom_bar)

func set_default_values(bar: ProgressBar):
	bar.min_value = min_value
	bar.max_value = max_value
	bar.value -= current_value

func set_current_value(value: float):
	current_value = clamp(value, min_value, max_value)
	run_tween(top_bar, current_value, 0.2, 0)
	run_tween(bottom_bar, current_value, 0.4, 0.1)

func run_tween(bar: ProgressBar, value: float, length: float, delay: float):
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", value, length).set_delay(delay)

func _process(delta: float) -> void:
	pass
