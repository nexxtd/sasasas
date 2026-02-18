extends Node

var chase_timer: Timer

func start_event() -> void:
	print("TV Monster Event Started")
	AudioDirector.play_sfx("tv_static")

	# Simulate delay before monster spawn
	await get_tree().create_timer(3.0).timeout

	EventBus.monster_spawned.emit()
	print("Monster Spawned! RUN!")

	# Start chase timer
	chase_timer = Timer.new()
	chase_timer.wait_time = 60.0 # 60 seconds to survive/escape
	chase_timer.one_shot = true
	chase_timer.timeout.connect(_on_chase_timeout)
	add_child(chase_timer)
	chase_timer.start()

	EventBus.monster_chase_started.emit()

	# Listen for safe zone reached
	EventBus.safe_zone_reached.connect(_on_safe_zone_reached)

func _on_chase_timeout() -> void:
	print("Failed to escape! YOU DIED.")
	EventBus.monster_chase_ended.emit()
	# Reset night progress (simplified by just ending night poorly or reloading)
	GameState.game_over.emit("Consumed by the anomaly")
	queue_free()

func _on_safe_zone_reached() -> void:
	print("Safe zone reached! You survived.")
	chase_timer.stop()
	EventBus.monster_chase_ended.emit()

	# Reward reduction in anomaly?
	GameState.add_anomaly(-10.0, "Survived Event")

	# End night
	StoreDirector.end_night_phase()
	queue_free()
