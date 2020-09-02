extends Control

var level = "dungeon"

signal level_selected

func _ready():
	pass # Replace with function body.

func _on_RouteSelect_pressed():
	# Send signal to gamescene, with the level selected
	emit_signal("level_selected", level)
	# Hide / remove  self
	self.queue_free()
