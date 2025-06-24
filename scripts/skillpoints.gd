extends Node2D

@onready var label: Label = get_node("Button/Amount")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	label.text = str(GlobalState.skillpoints)
