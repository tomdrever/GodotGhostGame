extends VBoxContainer

signal card_played(card)
signal highlight_card_action(card)
signal remove_card_action_highlights

var enabled = true

func _ready() -> void:
	add_child(Tween.new(), true)

func on_card_clicked(card) -> void:
	# TODO - scroll the camera to the player?
	if enabled:
		emit_signal("card_played", card)
		mouse_exited(card)
		enabled = false
	
func on_card_action_finished(card: Card) -> void:
	enabled = true

func add_card_to_hand(card: Card) -> void:
	# Let Hand listen to its buttonup signal
	card.connect("button_up", self, "on_card_clicked", [card])

	# Let Hand listen to it being focused/unfocused
	card.connect("mouse_entered", self, "mouse_entered", [card])
	card.connect("mouse_exited", self, "mouse_exited", [card])
	
	add_child(card)
	
func remove_card_from_hand(card: Card) -> void:
	# Clear card signals
	card.disconnect("button_up", self, "on_card_clicked")
	card.disconnect("mouse_entered", self, "mouse_entered")
	card.disconnect("mouse_exited", self, "mouse_exited")
	
	remove_child(card)
	
func mouse_entered(card: Card) -> void:
	_animate_card_focus(card, card.rect_scale, Vector2(1.2, 1.2))
	if enabled:
		emit_signal("highlight_card_action", card)
	
func mouse_exited(card: Card) -> void:
	_animate_card_focus(card, card.rect_scale, Vector2(1, 1))
	if enabled:
		emit_signal("remove_card_action_highlights")
	
func _animate_card_focus(card: Card, initial: Vector2, final: Vector2) -> void:
	var tween = card.tween
	if tween.is_active():
		tween.stop_all()
		
	tween.interpolate_property(card, "rect_scale", initial, final,  0.08,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
