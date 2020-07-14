extends Level

class_name DungeonLevel

func _init() -> void:
	size = Vector2(9, 30)
	floor_tile = TileManager.DUNGEON_FLOOR

func generate_obstacles() -> void:
	# Add 1-10 random-length walls
	for i in range(2 + randi() % 5):
		var y = randi() % int(size.y)
		var length = randi() % int(size.x - 1)
		var start_x = randi() % (int(size.x) - length)
		for x in range(start_x, start_x + length):
			if !obstacles.has(Vector2(x, y)):
				obstacles.append(Vector2(x, y))
				
func generate_enemies() -> void:
	# TESTING
	var enemy_pos = Vector2(size.x / 2, size.y - 5)
	enemies.append(enemy_pos)
	
	pass
