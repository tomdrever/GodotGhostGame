extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_player_reached_end() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	
	visible = true
