extends GameBoardActor

class_name Player

signal reached_end
signal hearts_changed(new_value)

var attack_dmg = 1

func _init() -> void:
	hearts = 2
	actor_name = "Player"

func take_damage(damage: int) -> void:
	hearts -= damage
	emit_signal("hearts_changed", hearts)
	print("Player took damage!")

func collide_with(actor: GameBoardActor) -> void:
	actor.hearts -= attack_dmg

func handle_move(target_position: Vector2) -> void:
	.handle_move(target_position)

	if get_parent().is_actor_at_end(self):
		emit_signal("reached_end")
