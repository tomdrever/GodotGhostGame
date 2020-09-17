extends TextureButton

class_name Card

var tween = Tween.new()
var data

func _ready() -> void:
	add_child(tween)
	rect_pivot_offset = rect_size / 2

func setup(_data) -> void:
	data = _data
	$Label.text = data["name"]
	
	var texture_file_name = "%s.png" % data["name"].replace(" ", "_").to_lower()
	
	$TextureRect.texture = load("res://assets/card/" + texture_file_name)
