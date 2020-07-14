extends Node2D

signal move_completed(success)

var level : Level

func _init() -> void:
	level = DungeonLevel.new()

func _ready() -> void:
	_generate_floor()
	level.generate_obstacles()
	level.generate_enemies()
	_setup_starting_positions()
	
func _get_subtile_coord(id):
	var tiles = $TileMap.tile_set
	var rect = $TileMap.tile_set.tile_get_region(id)
	var x = randi() % int(rect.size.x / tiles.autotile_get_size(id).x)
	var y = randi() % int(rect.size.y / tiles.autotile_get_size(id).y)
	return Vector2(x, y)
	
func _generate_floor() -> void:
	for x in range(0, level.size.x):
		for y in range(0, level.size.y):
			$TileMap.set_cell(x, y, level.floor_tile, false, false, false, _get_subtile_coord(2))
	
func _setup_starting_positions() -> void:
	var cell_size : Vector2 = $TileMap.cell_size
	var grid_size : Vector2 = cell_size * level.size
	
	# Add obstacles
	for obstacle_pos in level.obstacles:
		$TileMap.set_cellv(obstacle_pos, 3)
		$TileMap.update_bitmask_area(obstacle_pos)
	
	# Add enemies
	for enemy_pos in level.enemies:
		var enemy = preload("res://src/scenes/gameboard/Enemy.tscn").instance()
		enemy.position.x = cell_size.x * enemy_pos.x
		enemy.position.y = (cell_size.y * enemy_pos.y) - cell_size.y / 2
		
		enemy.add_to_group("game_board_actors")
		
		$Enemies.add_child(enemy)
	
	# Set up the camera
	$CameraFocus.setup(grid_size, cell_size)
	
	# Put the player in the starting position
	$Player.position.x = grid_size.x / 2
	$Player.position.y = grid_size.y - cell_size.y / 2
	
	$Player.add_to_group("game_board_actors")

func _highlight_tile(tile: Vector2, highlight: String) -> void:
	var highlight_sprite = Sprite.new()
	highlight_sprite.centered = false
	highlight_sprite.z_index = 1
	highlight_sprite.texture = load("res://assets/map/tiles/" + highlight)
	highlight_sprite.position = $TileMap.map_to_world(tile)
	$TileHighlights.add_child(highlight_sprite)

# Moves a Moveable GameboardActor 1 tile.
# This could be the player OR an enemy
func move(actor: GameBoardActor, direction: Vector2) -> void:
	var current_cell = $TileMap.world_to_map(actor.position)
	var target_cell = current_cell + direction
	
	# Restrict movement to within world
	if !$TileMap.get_used_rect().has_point(target_cell):
		emit_signal("move_completed", false)
		return
	
	# Check collision with obstacles
	for obstacle_pos in level.obstacles:
		if target_cell == obstacle_pos:
			emit_signal("move_completed", false)
			return
	
	# Check collision with gameboard actors (enemies, players and objects on the more
	# with more mechanics than "obstacle")
	for other_actor in get_tree().get_nodes_in_group("game_board_actors"):
		if target_cell == $TileMap.world_to_map(other_actor.position):
			print("Something tried to move into an enemy - handle this!")
			actor.collide_with(other_actor)
			other_actor.on_collision_with(actor)
	
	# TODO - Update camera position after player moves?
	
	# Get the moveable thing to handle any moving effects, and wait for it to finish
	actor.call_deferred("handle_move", $TileMap.map_to_world(target_cell) + $TileMap.cell_size / 2)
	yield(actor, "move_handled")
	
	# Let the CardHandler know that this move is finished, let it do the next part of the 
	# movement
	emit_signal("move_completed", true)

func highlight_card_action(card) -> void:
	# Determine card type
	if card.directions:
		var player_pos = $TileMap.world_to_map($Player.position)
		_highlight_tile(player_pos, "highlight_yellow.png")
		var previous_pos = player_pos
		
		for i in range(card.directions.size()):
			var new_pos = previous_pos + card.directions[i]
			if level.obstacles.has(new_pos): 
				_highlight_tile(new_pos, "highlight_red.png")
				return
			else:
				_highlight_tile(new_pos, "highlight_yellow.png")
			previous_pos = new_pos

func clear_tile_highlights() -> void:
	for highlight_sprite in $TileHighlights.get_children():
		highlight_sprite.queue_free()
