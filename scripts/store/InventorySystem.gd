extends Node

# Stores available products and their stock levels
# Dictionary mapping product_id (String) to quantity (int)
var stock: Dictionary = {}

# Product definitions (placeholder)
var products: Dictionary = {
	"chips": {"name": "Chips", "price": 2.5, "cost": 1.0},
	"soda": {"name": "Soda", "price": 1.5, "cost": 0.5},
	"bread": {"name": "Bread", "price": 3.0, "cost": 1.2},
	"milk": {"name": "Milk", "price": 4.0, "cost": 2.0},
	"cereal": {"name": "Cereal", "price": 5.0, "cost": 2.5}
}

func add_stock(product_id: String, quantity: int) -> void:
	if not products.has(product_id):
		printerr("Invalid product ID: ", product_id)
		return

	if stock.has(product_id):
		stock[product_id] += quantity
	else:
		stock[product_id] = quantity
	print("Added stock: ", product_id, " Qty: ", quantity, " New Total: ", stock[product_id])

func remove_stock(product_id: String, quantity: int) -> bool:
	if not stock.has(product_id) or stock[product_id] < quantity:
		return false

	stock[product_id] -= quantity
	print("Removed stock: ", product_id, " Qty: ", quantity, " Remaining: ", stock[product_id])
	return true

func buy_product(product_id: String, quantity: int) -> bool:
	if not products.has(product_id):
		return false

	var cost = products[product_id]["cost"] * quantity
	if GameState.remove_cash(cost):
		add_stock(product_id, quantity)
		return true
	else:
		print("Not enough cash to buy stock")
		return false

func get_product_info(product_id: String) -> Dictionary:
	return products.get(product_id, {})
