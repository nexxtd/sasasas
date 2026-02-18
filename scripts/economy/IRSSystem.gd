extends Node

const BASE_IRS_DUE = 150.0
const DEBT_INTEREST_RATE = 0.1 # 10% interest
const SUSPICION_PENALTY_MULTIPLIER = 2.0

func calculate_daily_irs_due(day_index: int, suspicion: float, current_debt: float) -> float:
	var due = BASE_IRS_DUE + (day_index * 50.0) # Increases daily
	due += current_debt * DEBT_INTEREST_RATE
	due += suspicion * SUSPICION_PENALTY_MULTIPLIER
	return due

func process_end_of_day_payment() -> Dictionary:
	var due = GameState.irs_due
	var cash = GameState.cash
	var paid = 0.0
	var new_debt = 0.0

	if cash >= due:
		paid = due
		GameState.remove_cash(due)
		print("IRS Payment Full: ", paid)
	else:
		paid = cash
		new_debt = due - cash
		GameState.remove_cash(cash) # Pay all you have
		GameState.add_debt(new_debt, "Unpaid IRS taxes")
		print("IRS Payment Partial: ", paid, " Debt added: ", new_debt)

	# Recalculate next day's due
	var next_due = calculate_daily_irs_due(GameState.day_index + 1, GameState.suspicion, GameState.debt)
	GameState.irs_due = next_due

	return {
		"due": due,
		"paid": paid,
		"debt_added": new_debt,
		"next_due": next_due
	}
