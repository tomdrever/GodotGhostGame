extends Node

func show(actor: GameBoardActor) -> void:
	var actor_tooltip = load("res://src/interface/GBATooltip.tscn").instance()
	actor_tooltip.rect_position = actor.get_global_transform_with_canvas().origin
	actor_tooltip.get_node("Label").text = actor.actor_name
	actor_tooltip.name = actor.name + "_tooltip"
	add_child(actor_tooltip)
	
func hide(actor: GameBoardActor) -> void:
	if has_node(actor.name + "_tooltip"):
		var actor_tooltip = get_node(actor.name + "_tooltip")
		actor_tooltip.queue_free()
