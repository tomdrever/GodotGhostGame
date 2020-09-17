extends TempMenu

func _ready() -> void:
	$Title.text = "Discard Pile"

func add_card_to_discard_pile(card: Card) -> void:
	$GridContainer.add_child(card)
	
func remove_card_from_discard_pile(card: Card) -> void:
	$GridContainer.remove_child(card)
