extends Action

class_name Movement

var directions : = [Vector2(1, 0), Vector2(0, -1), Vector2(0, -1), Vector2(0, -1)]

signal move(actor, directions)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play(actor: Node2D) -> void:
	emit_signal("move", actor, directions)
