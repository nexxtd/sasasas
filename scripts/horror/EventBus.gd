extends Node

# Horror events
signal horror_event_triggered(event_name: String)
signal night_started
signal power_outage_started
signal power_outage_ended
signal tv_turn_on
signal monster_spawned
signal monster_chase_started
signal monster_chase_ended
signal safe_zone_reached
signal night_ended

# Gameplay events
signal checkout_completed(customer_id: int, was_fraud: bool)
signal fraud_detected
