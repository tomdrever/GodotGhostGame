extends VBoxContainer

signal card_played(card)
signal highlight_card_action(card)
signal remove_card_action_highlights

var enabled = true

func _ready() -> void:
	add_child(Tween.new(), true)

func on_card_clicked(card) -> void:
	# TODO - scroll the camera to the player?
	if enabled:
		emit_signal("card_played", card)
		mouse_exited(card)
		enabled = false
	
func on_card_action_finished(card) -> void:
	enabled = true

# When the mouse hovers over a card (focuses on it), make card bigger (moving 
# other cards outwards?) (and signal to the game board to display overlay of 
# what the movement would be, or whatever the card does)
	
func mouse_entered(card) -> void:
	_animate_card_focus(card, card.rect_scale, Vector2(1.2, 1.2))
	if enabled:
		emit_signal("highlight_card_action", card)
	
func mouse_exited(card) -> void:
	_animate_card_focus(card, card.rect_scale, Vector2(1, 1))
	if enabled:
		emit_signal("remove_card_action_highlights")
	
func _animate_card_focus(card, initial, final) -> void:
	var tween = card.tween
	if tween.is_active():
		tween.stop_all()
		
	tween.interpolate_property(card, "rect_scale", initial, final,  0.08,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
