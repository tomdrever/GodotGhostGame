extends Node2D

class_name GameBoardActor

var hearts

var move_animation_speed = 0.2

signal move_handled
signal turn_finished

# Handles 
# - animating its own movement
# - colliding with something
# - being collided with

func _init() -> void:
	# Each actor needs its own Tween for movement animation
	add_child(Tween.new(), true)
	
func collide_with(actor: GameBoardActor) -> void:
	pass
	
func on_collision_with(actor: GameBoardActor) -> void:
	pass

func handle_move(target_position: Vector2) -> void:
	if has_node("AnimationPlayer"):
		$AnimationPlayer.stop()
	
	# Animate movement of sprite to new position
	var difference : Vector2 = (target_position - position).normalized()
	$Tween.interpolate_property($Sprite, "position", Vector2(), difference * 16,  move_animation_speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	# Wait for the animation to complete
	yield($Tween, "tween_completed")
	
	# If this actor has a hover animation, start it again
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("hover")
	
	# Update position and reset sprite position
	position = target_position
	$Sprite.position = Vector2()
	emit_signal("move_handled")
