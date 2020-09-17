extends Node

signal card_action_finished

func _init() -> void:
	randomize()

func _ready() -> void:
	# Screen / menu signals
	$UserInterface/FullScreen/Menus/LevelSelect.connect("level_started", $Game/Board, "on_level_started")
	$UserInterface/FullScreen/Menus/LevelSelect.connect("level_started", $UserInterface/FullScreen/Menus/Map, "on_level_started")
	$UserInterface/FullScreen/Menus/LevelSelect.connect("level_started", $Deck, "deal_starting_hand")
	
	# Player signals
	$Game/Board/Player.connect("reached_end", $UserInterface/FullScreen/Menus/EndOfLevel, "on_player_reached_end")
	$Game/Board/Player.connect("reached_end", self, "on_player_reached_end")
	$Game/Board/Player.connect("hearts_changed", $UserInterface/Left/LeftBar/Hearts, "hearts_changed")	
	
	# Board setup signals
	$Game/Board.connect("level_setup_finished", $Game/ParallaxForeground, "setup_overhangs")
	
	# Card signals
	$Deck.connect("add_card_to_hand", $UserInterface/Right/Hand, "add_card_to_hand")
	$Deck.connect("remove_card_from_hand", $UserInterface/Right/Hand, "remove_card_from_hand")
	
	$Deck.connect("add_card_to_draw_pile", $UserInterface/FullScreen/Menus/DrawPile, "add_card_to_draw_pile")
	$Deck.connect("remove_card_from_draw_pile", $UserInterface/FullScreen/Menus/DrawPile, "remove_card_from_draw_pile")
	
	$Deck.connect("add_card_to_discard_pile", $UserInterface/FullScreen/Menus/DiscardPile, "add_card_to_discard_pile")
	$Deck.connect("remove_card_from_discard_pile", $UserInterface/FullScreen/Menus/DiscardPile, "remove_card_from_discard_pile")
	
	$Deck.connect("add_card_to_draw_pile", $UserInterface/Right, "add_card_to_draw_pile")
	$Deck.connect("remove_card_from_draw_pile", $UserInterface/Right, "remove_card_from_draw_pile")
	
	$Deck.connect("add_card_to_discard_pile", $UserInterface/Right, "add_card_to_discard_pile")
	$Deck.connect("remove_card_from_discard_pile", $UserInterface/Right, "remove_card_from_discard_pile")
	
	
	$UserInterface/Right/Hand.connect("card_played", self, "on_card_played")
	$UserInterface/Right/Hand.connect("card_played", $Deck, "on_card_played")
	connect("card_action_finished", $UserInterface/Right/Hand, "on_card_action_finished")
	
	# (For now) the playing of a card triggers the board taking a turn (moving enemies, etc)
	connect("card_action_finished", $Game/Board, "handle_turn")
	$Game/Board.connect("board_turn_started", $UserInterface/Left/LeftBar/EnemyTurnIndicator, "turn_start")
	$Game/Board.connect("board_turn_ended", $UserInterface/Left/LeftBar/EnemyTurnIndicator, "turn_end")
	
	# Card highlight signals
	$UserInterface/Right/Hand.connect("highlight_card_action", $Game/Board, "highlight_card_action")
	$UserInterface/Right/Hand.connect("remove_card_action_highlights", $Game/Board, "remove_card_action_highlights")

	# Game board actor highlight signals
	$Game/Board.connect("actor_highlighted", $UserInterface/FullScreen/Tooltips, "show")
	$Game/Board.connect("actor_unhighlighted", $UserInterface/FullScreen/Tooltips, "hide")
	
	# Map interfaces
	$UserInterface/FullScreen/Menus/LevelSelect.setup()
	
func on_player_reached_end() -> void:
	$Game/Board.set_process(false)	

# TODO - move this into gameboard OR into some sort of cardactionhandler for 
# handling different kinds of card action 
func on_card_played(card) -> void:
	# TODO - handle different types of card - or have cards somehow store their own 
	# action and just play them
	for move in card.data["moves"]:
		$Game/Board.call_deferred("move", $Game/Board/Player, Vector2(move[0], move[1]))
		if !yield($Game/Board, "move_completed"):
			break
	emit_signal("card_action_finished", card)
