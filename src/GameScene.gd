extends Node

signal card_action_finished

# TODO - move some functionality to a CardHandler?

func _init() -> void:
	randomize()

func _ready() -> void:
	# Screen / menu signals
	$UserInterface/RouteSelectScreen.connect("level_selected", $GameBoard, "on_level_selected")
	$GameBoard/Player.connect("reached_end", $UserInterface/EndOfLevelScreen, "on_player_reached_end")
	
	# Board setup signals
	$GameBoard.connect("level_setup_finished", $ParallaxOverhangs, "setup_overhangs")
	
	# Card played signals
	$UserInterface/Deck/SideBar/Hand.connect("card_played", self, "on_card_played")
	connect("card_action_finished", $UserInterface/Deck/SideBar/Hand, "on_card_action_finished")
	
	# (For now) the playing of a card triggers the board taking a turn (moving enemies, etc)
	connect("card_action_finished", $GameBoard, "handle_turn")
	$GameBoard.connect("board_turn_started", $UserInterface/EnemyTurnIndicator, "turn_start")
	$GameBoard.connect("board_turn_ended", $UserInterface/EnemyTurnIndicator, "turn_end")
	
	# Card highlight signals
	$UserInterface/Deck/SideBar/Hand.connect("highlight_card_action", $GameBoard, "highlight_card_action")
	$UserInterface/Deck/SideBar/Hand.connect("remove_highlights", $GameBoard, "clear_tile_highlights")

func on_card_played(card) -> void:
	# TODO - handle different types of card - or have cards somehow store their own 
	# action and just play them
	for direction in card.directions:
		$GameBoard.call_deferred("move", $GameBoard/Player, direction)
		if !yield($GameBoard, "move_completed"):
			break
	emit_signal("card_action_finished", card)
