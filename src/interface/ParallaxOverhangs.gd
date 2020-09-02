extends ParallaxBackground

func setup_overhangs(level_width) -> void:
	$ParallaxLayer/OverhangRight.rect_position.x = $ParallaxLayer/OverhangLeft.rect_position.x + level_width
