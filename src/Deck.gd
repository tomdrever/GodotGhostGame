extends Node

var deck = "res://assets/data/decks/default.json"

var cards = []
var discard_pile = []
var draw_pile = []
var hand = []

signal add_card_to_hand(card)
signal remove_card_from_hand(card)

signal add_card_to_draw_pile(card)
signal remove_card_from_draw_pile(card)

signal add_card_to_discard_pile(card)
signal remove_card_from_discard_pile(card)

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_deck()
	
# Loads an array of cards from a json file
func _load_deck() -> void:
	# Open deck file
	var _cards = DataUtils.load_json(deck)
	for card in _cards:
		for i in range(card["number"]):
			var card_instance = card
			card_instance["id"] = card_instance["name"] + str(i)
			
			var card_scene = preload("res://src/interface/card/Card.tscn").instance()
			card_scene.setup(card_instance)
			cards.append(card_scene)
			
	cards.shuffle()

func deal_starting_hand(_level: Level) -> void:
	for card in cards:
		draw_pile.append(card)
		emit_signal("add_card_to_draw_pile", card)
	
	for _i in range(5):
		draw_card()

func draw_card():
	# If no more cards in draw pile, empty discard pile and shuffle the cards into draw pile
	if draw_pile.size() == 0:
		print("Shuffling discard pile into draw pile!")
		var discard_pile_cards = discard_pile
		discard_pile_cards.shuffle()
		for card in discard_pile_cards:
			discard_pile.remove(discard_pile.find(card))
			emit_signal("remove_card_from_discard_pile", card)
			
			draw_pile.append(card)
			emit_signal("add_card_to_draw_pile", card)
	
	# Choose a random card from the draw pile
	var random_index = randi() % draw_pile.size()
	var card = draw_pile[random_index]
	
	draw_pile.remove(random_index)
	emit_signal("remove_card_from_draw_pile", card)
			
	hand.append(card)
	emit_signal("add_card_to_hand", card)

	
func discard_card(card):
	hand.remove(hand.find(card))
	emit_signal("remove_card_from_hand", card)
			
	discard_pile.append(card)
	emit_signal("add_card_to_discard_pile", card)
	
func on_card_played(card):
	discard_card(card)
	draw_card()




