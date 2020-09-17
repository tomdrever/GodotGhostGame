extends Control

signal level_started

var level

var initial_level = {"name": "The Dungeon", "class":"res://src/levels/DungeonLevel.gd" }

func setup():
	if PlayerData.path == []:
		_start_level(initial_level)
	else:
		$VBoxContainer/LevelMap.generate_map(PlayerData.path, PlayerData.unlocks, true)

func on_level_button_pressed(_level):
	level = _level
	$VBoxContainer/LevelSelect.disabled = false
	$VBoxContainer/LevelSelect.text = level["name"]

func _on_Go_pressed():
	_start_level(level)

func _start_level(_level):
	PlayerData.path.append(_level["name"])
	# Send signal to gamescene, with the level selected
	emit_signal("level_started", load(_level["class"]).new())
	# Hide / remove  self
	self.queue_free()
