extends GameBoardActor

var attack_dmg = 1

func _init() -> void:
	hearts = 2

func collide_with(actor: GameBoardActor) -> void:
	actor.hearts -= attack_dmg
