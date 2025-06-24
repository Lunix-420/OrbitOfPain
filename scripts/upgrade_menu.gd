extends CanvasLayer

@onready var upgrade_menu:Node2D = get_node("Menu")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("open_upgrade_menu") and GlobalState.game_started:
		print("Hide") 
		upgrade_menu.visible = true	

func _on_closes_button_down() -> void:
	upgrade_menu.visible = false
