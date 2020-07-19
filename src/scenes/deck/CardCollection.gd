extends Control

export(String) var title : = "" 

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

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = false
		get_tree().paused = false
		
func on_toggle():
	visible = true
	get_tree().paused = true
