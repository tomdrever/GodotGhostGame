extends Enemy

class_name GhostEnemy

func init() -> void:
	actor_name = "Ghost"
	move_animation_speed = 0.2

	var moveset_json = DataUtils.load_json("res://assets/data/movesets/ghost.json")
	
	for action in moveset_json:
		var name = action["name"]
		var moves = []
		
		for move in action["moves"]:
			moves.append(Vector2(move[0], move[1]))
		
		moveset.append([name, moves])
	
	.init() 

func collide_with(actor: GameBoardActor) -> void:
	if actor is Player:
		actor.take_damage(1)
