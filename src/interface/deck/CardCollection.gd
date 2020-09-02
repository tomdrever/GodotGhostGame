extends Control

export(String) var title
export(String) var toggle_key

signal children_changed

func _ready() -> void:
	$Title.text = title

func add_card(card: Node) -> void:
	$GridContainer.add_child(card, false)
	emit_signal("children_changed")
	
func remove_card(card: Node) -> void:
	$GridContainer.remove_child(card)
	emit_signal("children_changed")
	
func get_cards():
	return $GridContainer.get_children()

func get_card_count():
	return $GridContainer.get_child_count()

# TODO - add key shortcuts for each card collection (D and F) which can toggle 
# their visibility 
func _input(event):
	if event.is_action_pressed(toggle_key):
		if !visible:
			var other_collections = get_tree().get_nodes_in_group("card_collections")
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
