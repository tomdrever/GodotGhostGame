extends Control

var draw_pile_count = 0
var discard_pile_count = 0

func add_card_to_draw_pile(_card: Card) -> void:
	draw_pile_count += 1
	$DrawPileButton.text = str("Draw Pile (", draw_pile_count, ")")
	
func remove_card_from_draw_pile(_card: Card) -> void:
	draw_pile_count -= 1
	$DrawPileButton.text = str("Draw Pile (", draw_pile_count, ")")
	
func add_card_to_discard_pile(_card: Card) -> void:
	discard_pile_count += 1
	$DiscardPileButton.text = str("Discard Pile (", discard_pile_count, ")")
	
func remove_card_from_discard_pile(_card: Card) -> void:
	discard_pile_count -= 1
	$DiscardPileButton.text = str("Discard Pile (", discard_pile_count, ")")
