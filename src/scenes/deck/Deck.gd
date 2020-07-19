tool
extends Control

export(String, FILE) var deck : = "" 

var cards : = []

func _ready() -> void:
	# Listen to on_card_played
	$SideBar/Hand.connect("card_played", self, "on_card_played")
	
	# Listen to the cardgridcontainers so the sidebar buttons can be updated
	$DrawPile.connect("children_changed", self, "update_draw_pile_text")
	$DiscardPile.connect("children_changed", self, "update_discard_pile_text")
	
	_load_deck()
	
	# At the start of the game, add all cards to the draw pile
	for card in cards:
		$DrawPile.add_card(card)
		
	# Then draw 5 cards
	for _i in range(5):
		draw_random_card()

# Loads an array of cards from a json file
func _load_deck() -> void:
	# Open deck file
	var file = File.new()
	if file.open(deck, File.READ) != 0:
		print("Error opening file" + str(deck))
		return

	# Read text
	var text = file.get_as_text()
	file.close()
	
	# Convert text to json
	var cards_json = parse_json(text)
	for card_json in cards_json:
		for _i in range(card_json["number"]):
			# Create Vector2 moves
			var directions = []
			for move in card_json["moves"]:
				directions.append(Vector2(move[0], move[1]))
			
			# Create new card, setup
			var card = preload("res://src/scenes/deck/card/Card.tscn").instance()
			card.setup(card_json["name"], directions)
			
			cards.append(card)
	
	cards.shuffle()

func on_card_played(card) -> void:
	discard_card(card)
	draw_random_card()

# Move card from DrawPile to Hand
func draw_card(card: Card) -> void:
	# Remove it from DrawPile
	$DrawPile.remove_card(card)
	
	# Add it to Hand
	$SideBar/Hand.add_child(card)
	
	# Let Hand listen to its buttonup signal
	card.connect("button_up", $SideBar/Hand, "on_card_clicked", [card])
	
	# Let Hand listen to it being focused/unfocused
	card.connect("mouse_entered", $SideBar/Hand, "mouse_entered", [card])
	card.connect("mouse_exited", $SideBar/Hand, "mouse_exited", [card])

func draw_random_card() -> void:
	# If no more cards in DrawPile, empty DiscardPile and shuffle the cards into Drawpile
	if $DrawPile.get_card_count() == 0:
		print("Shuffling discard pile into draw pile!")
		var discard_pile_cards = $DiscardPile.get_cards()
		discard_pile_cards.shuffle()
		for card in discard_pile_cards:
			$DiscardPile.remove_card(card)
			$DrawPile.add_card(card)
	
	# Get list of cards in DrawPile
	var draw_pile_cards = $DrawPile.get_cards()
	
	# Choose one at random
	var random_index = randi() % draw_pile_cards.size()
	var card = draw_pile_cards[random_index]
	
	draw_card(card)

# Move card from Hand to DiscardPile
func discard_card(card: Card) -> void:
	# Remove it from Hand
	$SideBar/Hand.remove_child(card)
	
	# Disconnect Hand from listening to when that card is clicked
	card.disconnect("button_up", $SideBar/Hand, "on_card_clicked");
	
	# TODO - is there a disconnect_all?
	card.disconnect("mouse_entered", $SideBar/Hand, "mouse_entered")
	card.disconnect("mouse_exited", $SideBar/Hand, "mouse_exited")
	
	# Add it to DiscardPile
	$DiscardPile.add_card(card)

func update_draw_pile_text() -> void:
	$SideBar/DrawPileButton.text = str("Draw Pile (", $DrawPile.get_card_count(), ")")

func update_discard_pile_text() -> void:
	$SideBar/DiscardPileButton.text = str("Discard Pile (", $DiscardPile.get_card_count(), ")")
