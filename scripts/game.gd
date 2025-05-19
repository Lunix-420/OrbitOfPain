extends Node2D

@onready var canvas_layer: CanvasLayer = get_node("CanvasLayer")
@onready var main_menu: Node2D = canvas_layer.get_node("MainMenu")
@onready var player: CharacterBody2D = get_node("Player")
@onready var ambience: AudioStreamPlayer = get_node("Ambience")

func _ready() -> void:
	ambience.play()
	

func _on_start_button_pressed() -> void:
	main_menu.visible = false
	player.visible = true	
	GlobalState.game_started = true
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
