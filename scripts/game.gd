extends Node2D

#==================================================================================================#
# Nodes

@onready var player: CharacterBody2D = get_node("Player")
@onready var ambience: AudioStreamPlayer = get_node("Ambience")

#==================================================================================================#
# Main Behaviors

func _ready() -> void:
	ambience.play()

func _input(event):
	if event.is_action_pressed("screenshot"):
		take_screenshot()

#==================================================================================================#
# Screenshot

func take_screenshot():
	var img = get_viewport().get_texture().get_image()
	var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
	var path = "user://screenshot_%s.png" % timestamp
	img.save_png(path)
	var dir = OS.get_data_dir() + "/screenshot_%s.png" % timestamp
	print("Screenshot saved to: ", dir)
