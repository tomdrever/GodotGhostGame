extends VBoxContainer

signal card_played(card)
signal highlight_card_action(card)
signal remove_highlights

var enabled = true

func on_card_clicked(card) -> void:
	# TODO - scroll the camera to the player?
	if enabled:
		emit_signal("card_played", card)
		on_card_unfocused()
		enabled = false
	
func on_card_action_finished() -> void:
	enabled = true

# When the mouse hovers over a card (focuses on it), make card bigger (moving 
# other cards outwards?) (and signal to the game board to display overlay of 
# what the movement would be, or whatever the card does)
	
func on_card_focused(card) -> void:
	if enabled:
		emit_signal("highlight_card_action", card)
	
func on_card_unfocused() -> void:
	if enabled:
		emit_signal("remove_highlights")
	
