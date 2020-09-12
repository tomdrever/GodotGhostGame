extends Control

class_name TempMenu

export(String) var toggle_key

func _input(event):
	if event.is_action_pressed(toggle_key):
		if !visible:
			var other_collections = get_tree().get_nodes_in_group("temp_menus")
			for collection in other_collections:
				if collection != self:
					collection.visible = false
					
			visible = true
		else:
			visible = false

func on_toggle():
	visible = true

func _on_Close_pressed():
	visible = false
