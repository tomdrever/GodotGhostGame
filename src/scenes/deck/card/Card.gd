extends TextureButton

class_name Card

var directions = []

signal card_focused(card)
signal card_unfocused

func _ready() -> void:
	rect_pivot_offset = rect_size / 2
	
	add_child(Tween.new(), true)
	
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")

func setup(name, _directions) -> void:
	$Label.text = name
	directions = _directions
	
	var texture_file_name = "%s.png" % name.replace(" ", "_").to_lower()
	
	$TextureRect.texture = load("res://assets/card/" + texture_file_name)
	
# On mouse enter, make card bigger (moving other cards outwards?) (and signal to the game 
# board to display overlay of what the movement would be, or whatever the card does)
func mouse_entered() -> void:
	_animate_card_focus(rect_scale, Vector2(1.2, 1.2))
	emit_signal("card_focused")

func mouse_exited() -> void:
	_animate_card_focus(rect_scale, Vector2(1, 1))
	emit_signal("card_unfocused")

func _animate_card_focus(initial, final) -> void:
	if $Tween.is_active():
		$Tween.stop_all()
		
	$Tween.interpolate_property(self, "rect_scale", initial, final,  0.08,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
