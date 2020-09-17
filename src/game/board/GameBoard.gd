extends Node2D

signal board_turn_started
signal board_turn_ended

signal actor_highlighted(actor)
signal actor_unhighlighted(actor)

signal level_setup_finished(level_width)

signal move_completed(success)

var level : Level

func _init() -> void:
	pass

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	for actor in get_tree().get_nodes_in_group("game_board_actors"):
		# NOTE - this works but assumes that each actor only takes up 1 tile
		# Actor's position is the centre of the sprite
		var actor_rect = Rect2(actor.position - ($TileMap.cell_size / 2), $TileMap.cell_size)
		
		var actor_currently_highlighted = actor_rect.has_point(get_global_mouse_position())
		
		if actor_currently_highlighted && !actor.highlighted:
			# Actor has just been highlighted!
			emit_signal("actor_highlighted", actor)
			_highlight_tile($TileMap.world_to_map(actor.position), "highlight_red.png", actor.name + "_highlight")
			
			actor.highlighted = true
			
		elif !actor_currently_highlighted && actor.highlighted:
			# Actor was highlighted but isn't any more
			emit_signal("actor_unhighlighted", actor)
			_clear_tile_highlights(actor.name + "_highlight")
			
			actor.highlighted = false

func _get_subtile_coord(id: int):
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
	var e_count = 0
	for enemy_data in level.enemies:
		var type = enemy_data[0]
		var pos = enemy_data[1]
		
		var enemy = load(type).instance()
		enemy.init()
		enemy.name = enemy.actor_name + "_" + str(e_count)
		enemy.position.x = cell_size.x * pos.x - cell_size.x / 2
		enemy.position.y = (cell_size.y * pos.y) - cell_size.y / 2
		
		enemy.add_to_group("game_board_actors")
		
		$Enemies.add_child(enemy)
		e_count += 1
	
	# Set up the camera
	$CameraFocus.setup(grid_size, cell_size)
	
	# Put the player in the starting position
	$Player.position.x = grid_size.x / 2
	$Player.position.y = grid_size.y - cell_size.y / 2
	
	$Player.add_to_group("game_board_actors")
	$Player.emit_signal("hearts_changed", $Player.hearts)

# Highlights a tile by creating a sprite with a given texture on top of that tile
func _highlight_tile(tile: Vector2, highlight: String, highlight_name: String) -> void:
	var highlight_sprite = Sprite.new()
	highlight_sprite.name = highlight_name
	highlight_sprite.centered = false
	highlight_sprite.z_index = 1
	highlight_sprite.texture = load("res://assets/map/tiles/" + highlight)
	highlight_sprite.position = $TileMap.map_to_world(tile)
	$TileHighlights.add_child(highlight_sprite)

# Deletes all sprites in the TileHighlights node where their name contains a given string
func _clear_tile_highlights(contains: String) -> void:
	for highlight_sprite in $TileHighlights.get_children():
		if contains in highlight_sprite.name:
			highlight_sprite.queue_free()

func _sort_by_y(a: Node2D, b: Node2D) -> bool:
	return a.position.y > b.position.y

func on_level_started(_level: Level) -> void:
	level = _level
	
	_generate_floor()
	level.generate_obstacles()
	level.generate_enemies()
	
	_setup_starting_positions()
	
	emit_signal("level_setup_finished", level.size.x * $TileMap.cell_size.x)

func handle_turn(_card_played: Card) -> void:	
	emit_signal("board_turn_started")
	
	# Remove player control of camera
	$CameraFocus.input_control = false
	
	# Sort the enemies by their Y position - from the bottom (largest) to the 
	# top (smallest)
	$Enemies.get_children().sort_custom(self, "_sort_by_y")
	
	for enemy in $Enemies.get_children():
		
		# Highlight the current enemy
		_highlight_tile($TileMap.world_to_map(enemy.position), "highlight_red.png", "enemy")
		
		# Move camera to enemy position
		$CameraFocus.call_deferred("move_to", enemy.position)
		yield($CameraFocus/Tween, "tween_completed")
		
		# TODO - better determining of the enemy's move, this is just random
		var move = enemy.moveset[randi() % enemy.moveset.size()]
		
		# Get the board to move bit by bit like normal
		for direction in move[1]:
			call_deferred("move", enemy, direction)
			if !yield(self, "move_completed"):
				break
				
		_clear_tile_highlights("enemy")
	
	# Move camera back tp player
	$CameraFocus.call_deferred("move_to", $Player.position)
	yield($CameraFocus/Tween, "tween_completed")
	
	# Yield control of camera to player
	$CameraFocus.input_control = true
	
	emit_signal("board_turn_ended")

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

func is_actor_at_end(actor: GameBoardActor) -> bool:
	return $TileMap.world_to_map(actor.position).y <= 1

func highlight_card_action(card: Card) -> void:
	# TODO - Determine and hadnle card types
	
	# Get the player's position, highlight it and use it to start checking each tile in 
	# that move's directions
	var player_pos = $TileMap.world_to_map($Player.position)
	_highlight_tile(player_pos, "highlight_yellow.png", "card_action_0")
	var previous_pos = player_pos
		
	for i in range(card.data["moves"].size()):
		var move = card.data["moves"][i]
		var new_pos = previous_pos + Vector2(move[0], move[1])
		# Check if path is out of bounds of the game board and if it is stop checking
		if !Rect2(Vector2(0, 0), level.size).has_point(new_pos):
			return
			
		# Check if obstacle is in path - if yes, highlight red and stop checking
		# If no, highlight the tile yellow (passable) and keep going
		if level.obstacles.has(new_pos): 
			_highlight_tile(new_pos, "highlight_red.png", "card_action_" + str(i+1))
			return
		else:
			_highlight_tile(new_pos, "highlight_yellow.png", "card_action_" + str(i+1))
		previous_pos = new_pos

func remove_card_action_highlights() -> void:
	_clear_tile_highlights("card_action")
