extends GridContainer

signal children_changed

func add_child(node: Node, legible_unique_name: bool = false) -> void:
	.add_child(node, legible_unique_name)
	emit_signal("children_changed")
	
func remove_child(node: Node) -> void:
	.remove_child(node)
	emit_signal("children_changed")
