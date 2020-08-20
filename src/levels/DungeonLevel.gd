extends Level

class_name DungeonLevel

func _init() -> void:
	size = Vector2(9, 30)
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
	for i in range(6):
		var rand_x = randi() % int(size.x)
		var rand_y = randi() % int(size.y)
		var new_enemy_pos = Vector2(rand_x, rand_y)
		
		if !obstacles.has(new_enemy_pos):
			print("Putting enemy on tile" + str(new_enemy_pos))
			enemies.append(new_enemy_pos)
