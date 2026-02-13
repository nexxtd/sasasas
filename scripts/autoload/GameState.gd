extends Node

signal day_changed(day_index: int)
signal cash_changed(new_cash: float)
signal suspicion_changed(new_value: float)
signal anomaly_changed(new_value: float)
signal game_over(reason: String)

var day_index: int = 1
var cash: float = 0.0
var suspicion: float = 0.0
var anomaly: float = 0.0
var debt: float = 0.0
var irs_due: float = 0.0

const MAX_DAYS = 3
const DEBT_LIMIT = 5000.0 # Example limit

func start_new_game() -> void:
	day_index = 1
	cash = 100.0 # Starting cash
	suspicion = 0.0
	anomaly = 0.0
	debt = 0.0
	irs_due = 200.0 # Initial IRS due
	emit_signal("day_changed", day_index)
	emit_signal("cash_changed", cash)
	emit_signal("suspicion_changed", suspicion)
	emit_signal("anomaly_changed", anomaly)

func advance_day() -> void:
	day_index += 1
	if day_index > MAX_DAYS:
		# Check for winning condition
		game_over.emit("You lasted")
	else:
		emit_signal("day_changed", day_index)

func add_cash(amount: float, source: String) -> void:
	cash += amount
	emit_signal("cash_changed", cash)
	print("Cash added: ", amount, " Source: ", source, " Total: ", cash)

func remove_cash(amount: float) -> bool:
	if cash >= amount:
		cash -= amount
		emit_signal("cash_changed", cash)
		return true
	return false

func add_debt(amount: float, reason: String) -> void:
	debt += amount
	print("Debt increased: ", amount, " Reason: ", reason, " Total: ", debt)
	if debt > DEBT_LIMIT:
		game_over.emit("Consumed by debt")

func add_suspicion(amount: float, reason: String) -> void:
	suspicion += amount
	emit_signal("suspicion_changed", suspicion)
	print("Suspicion increased: ", amount, " Reason: ", reason, " Total: ", suspicion)

func add_anomaly(amount: float, reason: String) -> void:
	anomaly += amount
	emit_signal("anomaly_changed", anomaly)
	print("Anomaly increased: ", amount, " Reason: ", reason, " Total: ", anomaly)

func get_state_dict() -> Dictionary:
	return {
		"day_index": day_index,
		"cash": cash,
		"suspicion": suspicion,
		"anomaly": anomaly,
		"debt": debt,
		"irs_due": irs_due
	}

func load_state_dict(data: Dictionary) -> void:
	day_index = data.get("day_index", 1)
	cash = data.get("cash", 100.0)
	suspicion = data.get("suspicion", 0.0)
	anomaly = data.get("anomaly", 0.0)
	debt = data.get("debt", 0.0)
	irs_due = data.get("irs_due", 200.0)

	emit_signal("day_changed", day_index)
	emit_signal("cash_changed", cash)
	emit_signal("suspicion_changed", suspicion)
	emit_signal("anomaly_changed", anomaly)
