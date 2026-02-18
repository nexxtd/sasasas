extends Node

const FRAUD_REWARD_MULTIPLIER = 1.2 # Gain 20% extra
const FRAUD_SUSPICION_COST = 5.0
const FRAUD_ANOMALY_COST = 2.0

func process_sale(total: float, fraud_type: StringName = &"none") -> void:
	var final_amount = total
	var suspicion_gain = 0.0
	var anomaly_gain = 0.0

	match fraud_type:
		&"overcharge_item":
			final_amount = total * FRAUD_REWARD_MULTIPLIER
			suspicion_gain = FRAUD_SUSPICION_COST
			anomaly_gain = FRAUD_ANOMALY_COST
			print("Fraud: Overcharge processed.")
		&"short_change":
			final_amount = total + 5.0 # Flat gain
			suspicion_gain = FRAUD_SUSPICION_COST
			anomaly_gain = FRAUD_ANOMALY_COST
			print("Fraud: Short change processed.")
		&"fake_scan_fee":
			final_amount = total + 2.0
			suspicion_gain = FRAUD_SUSPICION_COST * 0.5
			anomaly_gain = FRAUD_ANOMALY_COST * 0.5
			print("Fraud: Fake scan fee processed.")
		_:
			print("Standard sale processed.")

	GameState.add_cash(final_amount, "Sale")

	if suspicion_gain > 0:
		GameState.add_suspicion(suspicion_gain, "Fraud committed")
		EventBus.fraud_detected.emit()

	if anomaly_gain > 0:
		GameState.add_anomaly(anomaly_gain, "Fraud committed")

	# TODO: Maybe emit signal for sale complete to update UI or stats
