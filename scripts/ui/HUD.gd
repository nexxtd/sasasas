extends Control

@onready var cash_label = $CashLabel
@onready var day_label = $DayLabel

func _ready():
	GameState.cash_changed.connect(_on_cash_changed)
	GameState.day_changed.connect(_on_day_changed)
	_on_cash_changed(GameState.cash)
	_on_day_changed(GameState.day_index)

func _on_cash_changed(new_cash: float) -> void:
	cash_label.text = "Cash: $%d" % new_cash

func _on_day_changed(day: int) -> void:
	day_label.text = "Day: %d" % day
