extends Control

signal level_selected

func _ready():
	pass # Replace with function body.

func _on_RouteSelect_pressed():
	# Send signal to gamescene, with the level selected
	emit_signal("level_selected", DungeonLevel.new())
	# Hide / remove  self
	self.queue_free()
