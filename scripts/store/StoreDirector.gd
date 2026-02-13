extends Node

enum StoreState { CLOSED, OPEN, NIGHT_PHASE }
var current_state: StoreState = StoreState.CLOSED
var customers_served: int = 0
var max_customers: int = 10
var day_timer: Timer

signal store_opened
signal store_closed
signal night_started

func _ready():
	day_timer = Timer.new()
	day_timer.wait_time = 120.0 # 2 minutes per day for testing
	day_timer.one_shot = true
	day_timer.timeout.connect(_on_day_timer_timeout)
	add_child(day_timer)

func open_store() -> void:
	if current_state != StoreState.CLOSED:
		return

	current_state = StoreState.OPEN
	customers_served = 0
	day_timer.start()
	emit_signal("store_opened")
	print("Store Opened. Day: ", GameState.day_index)

func close_store() -> void:
	if current_state != StoreState.OPEN:
		return

	current_state = StoreState.CLOSED
	day_timer.stop()
	emit_signal("store_closed")
	print("Store Closed.")

	_process_end_of_day()

func _on_day_timer_timeout() -> void:
	close_store()

func _process_end_of_day() -> void:
	# Calculate IRS and debt
	var irs_results = IRSSystem.process_end_of_day_payment()
	# TODO: Show summary screen with irs_results

	start_night_phase()

func start_night_phase() -> void:
	current_state = StoreState.NIGHT_PHASE
	emit_signal("night_started")
	EventBus.night_started.emit()
	print("Night Phase Started")
	# Trigger horror director logic here
	# HorrorDirector.evaluate_night_events(GameState.day_index, GameState.anomaly)

func end_night_phase() -> void:
	current_state = StoreState.CLOSED
	EventBus.night_ended.emit()
	GameState.advance_day()
	print("Night Ended. New Day: ", GameState.day_index)
