extends HBoxContainer

var heart_texture = preload("res://assets/ui/heart.png")

func hearts_changed(value: int) -> void:
	for child in get_children():
		child.queue_free()
		
	for _i in range(value):
		var heart = TextureRect.new()
		heart.rect_min_size = Vector2(40, 40)
		heart.texture = heart_texture
		heart.expand = true
		add_child(heart)
