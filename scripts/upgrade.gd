extends Control

@onready var button: Button =  get_node("Button")

@export var title_string: String
@onready var title: Control = button.get_node("Title")

@export var text_string: String
@onready var text: Control = button.get_node("Text")

@export var icon_texture: Texture
@onready var icon: Sprite2D = button.get_node("Icon")

@export var perk: String

func _ready() -> void:
	button.toggle_mode = true
	title.text = title_string
	text.text = text_string
	icon.texture = icon_texture
	

func _process(_delta: float) -> void:
	pass

func _on_button_down() -> void:
	if GlobalState.skillpoints > 0 and not GlobalState.perks[perk]:
		GlobalState.skillpoints -= 1
		GlobalState.perks[perk]=true
		button.disabled = true
		# Force redraw
		button.visible = false
		button.visible = true
