extends CanvasLayer

@onready var upgrade_menu: Node2D = get_node("UpgradeMenu")
@onready var break_menu: Node2D = get_node("BreakMenu")
@onready var camera: Node2D = get_parent()
@onready var player: Node2D = camera.get_parent()
@onready var spawner: Node2D = player.get_node("Spawner")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("open_upgrade_menu") and GlobalState.game_started:
		upgrade_menu.visible = true	

func _on_closes_button_down() -> void:
	upgrade_menu.visible = false
	if spawner.state == spawner.GameState.BREAK:
		break_menu.visible = true

func _on_buy_button_down() -> void:
	upgrade_menu.visible = true
	break_menu.visible = false
	
func _on_next_button_down() -> void:
	spawner.start_next_wave()
	break_menu.visible = false

#===================================================================================================
# Spawner Events

func on_enter_break() -> void:
	if not upgrade_menu.visible:
		break_menu.visible = true

func on_enter_wave() -> void:
	break_menu.visible = false

func on_enter_endless() -> void:
	pass
