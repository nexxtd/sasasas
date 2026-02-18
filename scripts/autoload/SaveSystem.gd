extends Node

const SAVE_PATH = "user://save_game.dat"

func save_game() -> void:
	var state = GameState.get_state_dict()
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json = JSON.new()
		var json_string = json.stringify(state)
		file.store_string(json_string)
		print("Game saved to ", SAVE_PATH)
	else:
		printerr("Failed to save game.")

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(content)
		if error == OK:
			var data = json.data
			if typeof(data) == TYPE_DICTIONARY:
				GameState.load_state_dict(data)
				print("Game loaded from ", SAVE_PATH)
				return true
			else:
				printerr("Save file format error")
		else:
			printerr("JSON Parse Error: ", json.get_error_message())
	return false
