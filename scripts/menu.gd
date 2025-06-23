extends CanvasLayer

#==================================================================================================#
# Nodes

@onready var main_menu: Node2D = get_node("MainMenu")
@onready var help_menu: Node2D = get_node("HelpMenu")
@onready var credits_menu: Node2D = get_node("CreditsMenu")

@onready var player: CharacterBody2D = get_parent().get_node("Player")
@onready var camera: Camera2D = player.get_node("Camera")
@onready var upgrade_menu: Node2D = camera.get_node("UpgradeMenu").get_node("Menu")

#==================================================================================================#
# Main Behaviors

# Handle inputs
func _input(_event):
	pass
	
#==================================================================================================#
# Button Behaviors

# Start the gameplay
func _on_start_button_pressed() -> void:
	main_menu.visible = false
	GlobalState.game_started = true
	player.visible = true

# Close the game
func _on_exit_button_pressed() -> void:
	if OS.has_feature("HTML5"):
		JavaScriptBridge.eval("window.location.href = 'https://lunix420.itch.io/orbit-of-pain';")
	else:
		get_tree().quit()

# Go to the help menu
func _on_controls_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = true
	credits_menu.visible = false
	upgrade_menu.visible = false

# Go to the credits menu
func _on_credits_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = false
	credits_menu.visible = true
	upgrade_menu.visible = false

# Exit the help menu and go back to the main menu
func _on_exit_help_button_pressed() -> void:
	main_menu.visible = true
	help_menu.visible = false
	credits_menu.visible = false
	upgrade_menu.visible = false

# Exit the credits menu and go back to the main menu
func _on_exit_credits_button_pressed() -> void:
	main_menu.visible = true
	help_menu.visible = false
	credits_menu.visible = false
	upgrade_menu.visible = false

# Close the upgrade menu
func _on_exit_upgrade_menu_button_down() -> void:
	main_menu.visible = false
	help_menu.visible = false
	credits_menu.visible = false
	upgrade_menu.visible = false
