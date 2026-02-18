extends Node
class_name CheckoutSystem

# Represents the current checkout session
var current_customer_id: int = -1
var basket_items: Array = []
var basket_total: float = 0.0
var scanned_items: Array = []
var scanned_total: float = 0.0

signal checkout_started(customer_id: int, items: Array)
signal item_scanned(item_id: String, price: float)
signal checkout_finished(total_paid: float, fraud_type: StringName)

func start_checkout(customer_id: int, items: Array) -> void:
	current_customer_id = customer_id
	basket_items = items
	basket_total = _calculate_total(items)
	scanned_items = []
	scanned_total = 0.0
	emit_signal("checkout_started", customer_id, items)
	print("Checkout Started for Customer ", customer_id, " with ", items.size(), " items.")

func scan_item(item_index: int) -> void:
	if item_index < 0 or item_index >= basket_items.size():
		return

	var item_id = basket_items[item_index]
	var price = InventorySystem.products.get(item_id, {}).get("price", 0.0)

	scanned_items.append(item_id)
	scanned_total += price
	emit_signal("item_scanned", item_id, price)
	print("Scanned: ", item_id, " Price: ", price)

func complete_checkout(fraud_type: StringName) -> void:
	EconomySystem.process_sale(scanned_total, fraud_type)
	EventBus.checkout_completed.emit(current_customer_id, fraud_type != &"none")

	emit_signal("checkout_finished", scanned_total, fraud_type)
	print("Checkout Finished. Fraud Type: ", fraud_type)

func _calculate_total(items: Array) -> float:
	var total = 0.0
	for item in items:
		total += InventorySystem.products.get(item, {}).get("price", 0.0)
	return total
