extends TempMenu

func _ready() -> void:
	$Title.text = "Draw Pile"

func add_card_to_draw_pile(card: Card) -> void:
	$GridContainer.add_child(card)
	
func remove_card_from_draw_pile(card: Card) -> void:
	$GridContainer.remove_child(card)
