extends Node

func play_sfx(sfx_name: String, position: Vector3 = Vector3.ZERO) -> void:
	print("Playing SFX: ", sfx_name, " at ", position)
	# TODO: Implement actual audio playback

func play_music(music_name: String) -> void:
	print("Playing Music: ", music_name)
	# TODO: Implement actual music playback

func stop_music() -> void:
	print("Stopping Music")
	# TODO: Implement music stop

func play_ambience(ambience_name: String) -> void:
	print("Playing Ambience: ", ambience_name)
	# TODO: Implement ambience playback
