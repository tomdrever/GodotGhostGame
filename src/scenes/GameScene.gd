extends Node2D

signal card_action_finished

# TODO - replace with CardHandler?

func _init() -> void:
	randomize()

func _ready() -> void:
	$UserInterface/Deck/SideBar/Hand.connect("card_played", self, "on_card_played")
	connect("card_action_finished", $UserInterface/Deck/SideBar/Hand, "on_card_action_finished")
	
	$UserInterface/Deck/SideBar/Hand.connect("highlight_card_action", $GameBoard, "highlight_card_action")
	$UserInterface/Deck/SideBar/Hand.connect("remove_highlights", $GameBoard, "clear_tile_highlights")

func on_card_played(card) -> void:
	# TODO - handle different types of card - or have cards somehow store their own 
	# action and just play them
	for direction in card.directions:
		$GameBoard.call_deferred("move", $GameBoard/Player, direction)
		if !yield($GameBoard, "move_completed"):
			break
	emit_signal("card_action_finished")
