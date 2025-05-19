extends Node2D

@onready var player: CharacterBody2D = get_node("Player")
@onready var ambience: AudioStreamPlayer = get_node("Ambience")

func _ready() -> void:
	ambience.play()	
