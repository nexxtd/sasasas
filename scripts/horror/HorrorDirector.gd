extends Node

const ANOMALY_TIER_1 = 20.0
const ANOMALY_TIER_2 = 50.0
const ANOMALY_TIER_3 = 80.0

var events: Array = []
var event_timer: Timer

func _ready():
	event_timer = Timer.new()
	event_timer.wait_time = 30.0 # Check for events every 30 seconds
	event_timer.timeout.connect(_on_event_timer_timeout)
	add_child(event_timer)

	EventBus.night_started.connect(_on_night_started)
	EventBus.night_ended.connect(_on_night_ended)

func _on_night_started() -> void:
	print("Horror Director: Night Started")
	event_timer.start()
	evaluate_night_events(GameState.day_index, GameState.anomaly)

func _on_night_ended() -> void:
	print("Horror Director: Night Ended")
	event_timer.stop()

func evaluate_night_events(day_index: int, anomaly: float) -> void:
	print("Evaluating Horror Events. Anomaly: ", anomaly)

	if day_index == 3 or anomaly >= ANOMALY_TIER_3:
		trigger_tv_monster_event()
	elif anomaly >= ANOMALY_TIER_2:
		trigger_power_outage()
	elif anomaly >= ANOMALY_TIER_1:
		trigger_glitch_event()
	else:
		print("Anomaly too low for major events.")

func _on_event_timer_timeout() -> void:
	evaluate_night_events(GameState.day_index, GameState.anomaly)

func trigger_tv_monster_event() -> void:
	print("TRIGGERING TV MONSTER EVENT")
	EventBus.tv_turn_on.emit()
	# This would instantiate the event scene or start logic
	var event_scene = load("res://scenes/events/TVMonsterEvent.tscn").instantiate()
	add_child(event_scene)
	event_scene.start_event()

func trigger_power_outage() -> void:
	print("TRIGGERING POWER OUTAGE")
	EventBus.power_outage_started.emit()

func trigger_glitch_event() -> void:
	print("TRIGGERING GLITCH EVENT")
	EventBus.horror_event_triggered.emit("glitch")
