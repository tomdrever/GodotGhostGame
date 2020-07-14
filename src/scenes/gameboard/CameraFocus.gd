tool
extends Position2D

export(int) var SCROLL_SPEED := 0

var _limit_top : float = 0
var _limit_bottom : float = 0

# TODO - update _limit_bottom as character moves up?

func _process(delta: float) -> void:
	if Input.is_action_just_released("camera_up"):
		move(-SCROLL_SPEED, delta)
	elif Input.is_action_just_released("camera_down"):
		move(SCROLL_SPEED, delta)

func move(amount: float, delta: float) -> void:
	position[1] += amount * delta
	position[1] = clamp(position[1], _limit_top, _limit_bottom)
	
func setup(grid_size: Vector2, cell_size: Vector2) -> void:
	# Set the camera's limits based on the size of the world grid
	var limit_border : float = ((get_viewport_rect().size[1] * $Camera2D.zoom[1]) / 2) - (2*cell_size.y)
	_limit_top = limit_border
	_limit_bottom = grid_size.y - limit_border
	
	# Centre the camera on the middle of the world grid
	position.x += grid_size.x / 2
	
	# Move the camera to the bottom of the world grid (the start)
	position.y = _limit_bottom
	
