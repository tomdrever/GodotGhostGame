extends GameBoardActor

class_name Enemy

var moveset : = []

signal enemy_move

func _init() -> void:
	._init()
	hearts = 1

func on_collision_with(actor: GameBoardActor) -> void:
	if hearts <= 0:
		print("Enemy killed!")
		queue_free()
		
func take_turn() -> void:
	emit_signal("turn_finished")
