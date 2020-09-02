extends Level

class_name DungeonLevel

var basic_enemy = "res://src/gameboard/actors/GhostEnemy.tscn"

func _init() -> void:
	size = Vector2(7, 24)
	floor_tile = TileManager.DUNGEON_FLOOR

func generate_obstacles() -> void:
	# Add 1-10 random-length walls
	for i in range(2 + randi() % 5):
		var y = 1 + (randi() % int(size.y - 1))
		var length = randi() % int(size.x - 1)
		var start_x = randi() % (int(size.x) - length)
		for x in range(start_x, start_x + length):
			var new_obstacle_pos = Vector2(x, y)
			if !obstacles.has(new_obstacle_pos):
				obstacles.append(new_obstacle_pos)
				
func generate_enemies() -> void:
	# Try to put 6 enemies on the board in random positions
	# If there's an obstacle in the way don't place an enemy there
	for i in range(4):
		var rand_x = randi() % int(size.x)
		var rand_y = randi() % int(size.y)
		var new_enemy_data = [basic_enemy, Vector2(rand_x, rand_y)]
		
		if !obstacles.has(new_enemy_data[1]):
			enemies.append(new_enemy_data)
