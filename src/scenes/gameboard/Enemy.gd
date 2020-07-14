extends GameBoardActor

func _init() -> void:
	hearts = 1

func on_collision_with(actor: GameBoardActor) -> void:
	if hearts <= 0:
		print("Enemy killed!")
		queue_free()
