extends CanvasLayer

@onready var main_menu: Node2D = get_node("MainMenu")
@onready var help_menu: Node2D = get_node("HelpMenu")
@onready var credits_menu:  Node2D = get_node("CreditsMenu")
@onready var player: CharacterBody2D = get_parent().get_node("Player")

func _on_start_button_pressed() -> void:
	main_menu.visible = false
	player.visible = true	
	GlobalState.game_started = true
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_controls_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = true
	credits_menu.visible = false
	
func _on_exit_help_button_pressed() -> void:
	main_menu.visible = true
	help_menu.visible = false
	credits_menu.visible = false


func _on_exit_credits_button_pressed() -> void:
	main_menu.visible = true
	help_menu.visible = false
	credits_menu.visible = false


func _on_credits_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = false
	credits_menu.visible = true
