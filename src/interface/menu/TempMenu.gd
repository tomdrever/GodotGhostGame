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
					
			show_menu()
		else:
			hide_menu()

func on_toggle():
	show_menu()

func _on_Close_pressed():
	hide_menu()

func show_menu():
	visible = true

func hide_menu():
	visible = false
