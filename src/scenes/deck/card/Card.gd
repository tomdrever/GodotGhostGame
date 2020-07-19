extends TextureButton

class_name Card

var tween = Tween.new()
var directions = []

func _ready() -> void:
	add_child(tween)
	rect_pivot_offset = rect_size / 2

func setup(name, _directions) -> void:
	$Label.text = name
	directions = _directions
	
	var texture_file_name = "%s.png" % name.replace(" ", "_").to_lower()
	
	$TextureRect.texture = load("res://assets/card/" + texture_file_name)
