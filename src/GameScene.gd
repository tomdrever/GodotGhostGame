extends Node

signal card_action_finished

func _init() -> void:
	randomize()

func _ready() -> void:
	# Screen / menu signals
	$UserInterface/LevelSelectScreen.connect("level_started", $Game/Board, "on_level_started")
	$UserInterface/LevelSelectScreen.connect("level_started", $UserInterface/MapMenu, "on_level_started")
	
	$Game/Board/Player.connect("reached_end", $UserInterface/EndOfLevelScreen, "on_player_reached_end")
	$Game/Board/Player.connect("reached_end", self, "on_player_reached_end")
	
	$Game/Board/Player.connect("hearts_changed", $UserInterface/LeftBar/Hearts, "hearts_changed")	
	
	# Board setup signals
	$Game/Board.connect("level_setup_finished", $Game/ParallaxForeground, "setup_overhangs")
	
	# Card played signals
	$UserInterface/Deck/SideBar/Hand.connect("card_played", self, "on_card_played")
	connect("card_action_finished", $UserInterface/Deck/SideBar/Hand, "on_card_action_finished")
	
	# (For now) the playing of a card triggers the board taking a turn (moving enemies, etc)
	connect("card_action_finished", $Game/Board, "handle_turn")
	$Game/Board.connect("board_turn_started", $UserInterface/LeftBar/EnemyTurnIndicator, "turn_start")
	$Game/Board.connect("board_turn_ended", $UserInterface/LeftBar/EnemyTurnIndicator, "turn_end")
	
	# Card highlight signals
	$UserInterface/Deck/SideBar/Hand.connect("highlight_card_action", $Game/Board, "highlight_card_action")
	$UserInterface/Deck/SideBar/Hand.connect("remove_card_action_highlights", $Game/Board, "remove_card_action_highlights")

	# Game board actor highlight signals
	$Game/Board.connect("actor_highlighted", $UserInterface/Tooltips, "show")
	$Game/Board.connect("actor_unhighlighted", $UserInterface/Tooltips, "hide")
	
	# Map interfaces
	$UserInterface/LevelSelectScreen.setup()
	
func on_player_reached_end() -> void:
	$Game/Board.set_process(false)	

# TODO - move this into gameboard OR into some sort of cardactionhandler for 
# handling different kinds of card action 
func on_card_played(card) -> void:
	# TODO - handle different types of card - or have cards somehow store their own 
	# action and just play them
	for direction in card.directions:
		$Game/Board.call_deferred("move", $Game/Board/Player, direction)
		if !yield($Game/Board, "move_completed"):
			break
	emit_signal("card_action_finished", card)
