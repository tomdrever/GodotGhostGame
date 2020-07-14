extends Node

# needs to be reactive i.e. reacts to player's turn ending
# need player_turn_ended signal which, when received, triggers looping thru of all 
# other actors turns - using signals and defered_calls
# AIGameBoardActor class - has take_turn() function - enemies and such extend that 
# instead of just gameboardactor
