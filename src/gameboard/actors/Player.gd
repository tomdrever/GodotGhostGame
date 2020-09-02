extends GameBoardActor

signal reached_end

var attack_dmg = 1

func _init() -> void:
	hearts = 2

func collide_with(actor: GameBoardActor) -> void:
	actor.hearts -= attack_dmg

func handle_move(target_position: Vector2) -> void:
	.handle_move(target_position)

	if get_parent().is_actor_at_end(self):
		emit_signal("reached_end")
