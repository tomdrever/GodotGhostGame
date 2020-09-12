extends Node

func load_json(file_dir: String) -> Array:
	var file = File.new()
	if file.open(file_dir, File.READ) != 0:
		push_error("Error opening file" + str(file_dir))
		return []

	# Read text
	var text = file.get_as_text()
	file.close()
	
	# Convert text to json
	return parse_json(text)
