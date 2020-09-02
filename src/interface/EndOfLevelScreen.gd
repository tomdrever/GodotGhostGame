extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_player_reached_end() -> void:
	# TODO - Pause the game board 
	visible = true
