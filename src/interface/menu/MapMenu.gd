extends TempMenu

func on_level_started(level: Level) -> void:
	$LevelMap.generate_map(PlayerData.path, PlayerData.unlocks, false)
