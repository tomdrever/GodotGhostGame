extends Enemy

class_name GhostEnemy

func _init() -> void:
	._init() 
	
	move_animation_speed = 0.2

	var moveset_json = DataUtils.load_json("res://assets/data/movesets/ghost.json")
	
	# TODO - rename these, they're really bad
	for move in moveset_json:
		var name = move["name"]
		var directions = []
		
		for direction in move["moves"]:
			directions.append(Vector2(direction[0], direction[1]))
		
		moveset.append([name, directions])
