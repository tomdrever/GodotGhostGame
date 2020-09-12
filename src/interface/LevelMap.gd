extends Control

var DEFAULT_LINE_COLOR = Color(0.4, 0.5, 1, 1)
var PATH_COLOR = Color(1, 0.5, 1)
var BUTTON_SIZE = Vector2(32, 32)

signal level_selected

func generate_map(player_path: Array, player_unlock: int, selecting: bool):
	var layers = DataUtils.load_json("res://assets/data/levels.json")
	
	var y_offset = rect_min_size.y / (layers.size() + 1)
	
	for layer_num in range(layers.size()):
		# Draw buttons
		
		# For each level on this layer
		for level_num in range(layers[layer_num].size()):
			var level = layers[layer_num][level_num]
			
			# If the player hasn't unlocked this level yet, don't create a level button for it
			if level.has("unlock") && player_unlock < level["unlock"]:
				continue
			
			# Create a level button
			var level_button = TextureButton.new()
			level_button.rect_min_size = BUTTON_SIZE
			level_button.hint_tooltip = level["name"]
			if player_path.has(level["name"]):
				level_button.modulate = PATH_COLOR
			level_button.texture_normal = load("res://assets/ui/level_button.png")
			level_button.texture_hover = load("res://assets/ui/level_button_hover.png")
		
			# Determine button position
			var button_y = rect_min_size.y - (y_offset + (y_offset * layer_num) + (level_button.rect_min_size.y / 2))
			var button_x = 0
			match level_num:
				0:
					button_x = rect_min_size.x * 0.50 - BUTTON_SIZE.x / 2
				1:
					button_x = rect_min_size.x * 0.25 - BUTTON_SIZE.x / 2
				2:
					button_x = rect_min_size.x * 0.75 - BUTTON_SIZE.x / 2
			level_button.rect_position = Vector2(button_x, button_y)
			
			if selecting:
				level_button.connect("pressed", get_parent().get_parent(), "on_level_button_pressed", [level])
				
				# Disable all buttons that aren't on the next layer
				if layer_num != player_path.size():
					level_button.disabled = true
			else:
				level_button.disabled = true
			
			add_child(level_button)
		
		# Draw lines to next layer
		
		# Don't need to if there is no next layer
		if layer_num == layers.size() - 1:
			break
			
		# For each level in this layer, draw a line to the next layer
		for level_num in range(layers[layer_num].size()):
			var level = layers[layer_num][level_num]
			# If the player hasn't unlocked this level yet, don't draw a line from it
			if level.has("unlock") && player_unlock < level["unlock"]:
				continue
			
			var this_layer_pos = Vector2(rect_min_size.x / 2, rect_min_size.y - (y_offset + (y_offset * layer_num)))
			# Offset positions for non-main levels
			match level_num:
				1:
					this_layer_pos.x -= rect_min_size.x / 4
				2:
					this_layer_pos.x += rect_min_size.x / 4
			var next_layer_pos = Vector2(rect_min_size.x / 2, rect_min_size.y - (y_offset + (y_offset * (layer_num+1))))
			
			var color = PATH_COLOR if player_path.has(layers[layer_num][level_num]["name"]) && player_path.has(layers[layer_num+1][0]["name"]) else DEFAULT_LINE_COLOR
			
			$Lines.add_child(_make_line(this_layer_pos, next_layer_pos, color))
			
		# For each non-main level in the next layer, draw a line to it
		for level_num in range(layers[layer_num+1].size()):
			var level = layers[layer_num+1][level_num]
			# If the player hasn't unlocked this level yet, don't create a level button for it
			if level.has("unlock") && player_unlock < level["unlock"]:
				continue
			
			var this_layer_pos = Vector2(rect_min_size.x / 2, rect_min_size.y - (y_offset + (y_offset * layer_num)))
			var next_layer_pos = Vector2(rect_min_size.x / 2, rect_min_size.y - (y_offset + (y_offset * (layer_num+1))))
			# Offset positions for non-main levels
			match level_num:
				1:
					next_layer_pos.x -= rect_min_size.x / 4
				2:
					next_layer_pos.x += rect_min_size.x / 4
			
			var color = PATH_COLOR if player_path.has(layers[layer_num][0]["name"]) && player_path.has(layers[layer_num+1][level_num]["name"]) else DEFAULT_LINE_COLOR
			
			$Lines.add_child(_make_line(this_layer_pos, next_layer_pos, color))
	
func _make_line(from: Vector2, to: Vector2, color: Color) -> Line2D:
	var line = Line2D.new()
	line.default_color = color
	line.width = 6
	line.points = PoolVector2Array([from, to])
	return line
