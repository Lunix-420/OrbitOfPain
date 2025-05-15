extends Control

@export var player_path: NodePath
var player: Node2D
var offset: Vector2

func _ready() -> void:
	player = get_node(player_path)
	offset = position - player.global_position

func _process(delta: float) -> void:
	if not player:
		return
	position = player.global_position + offset
