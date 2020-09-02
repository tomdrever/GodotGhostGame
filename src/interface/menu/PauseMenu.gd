extends Control

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = !visible
		get_tree().paused = !get_tree().paused

func _on_Resume_pressed():
	visible = false
	get_tree().paused = false
