extends CharacterBody3D
class_name CustomerAI

enum CustomerState { ENTERING, SHOPPING, QUEUING, CHECKOUT, LEAVING }

var state: CustomerState = CustomerState.ENTERING
var shopping_list: Array = []
var customer_id: int = 0
var target_position: Vector3 = Vector3.ZERO

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

signal reached_checkout(customer_id: int, basket_total: float)
signal left_store(customer_id: int, satisfied: bool)

func _ready():
	customer_id = randi()
	_generate_shopping_list()
	# TODO: Set target to shelf

func _physics_process(delta):
	# Movement logic using NavigationAgent3D
	if nav_agent.is_navigation_finished():
		_on_navigation_finished()
		return

	var next_path_position: Vector3 = nav_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * 3.0 # Speed
	velocity = new_velocity
	move_and_slide()

func _generate_shopping_list() -> void:
	shopping_list = []
	var num_items = randi_range(1, 5)
	var products = InventorySystem.products.keys()
	if products.is_empty():
		return

	for i in range(num_items):
		var item = products.pick_random()
		shopping_list.append(item)
	print("Customer ", customer_id, " shopping list: ", shopping_list)

func _on_navigation_finished() -> void:
	match state:
		CustomerState.ENTERING:
			state = CustomerState.SHOPPING
			# Determine next shelf target
			# For MVP, just go to checkout immediately or random spot
			state = CustomerState.QUEUING
			_go_to_checkout()
		CustomerState.SHOPPING:
			# Collect item, maybe go to next or checkout
			pass
		CustomerState.QUEUING:
			state = CustomerState.CHECKOUT
			reached_checkout.emit(customer_id, 0.0) # Total calculated by CheckoutSystem
		CustomerState.LEAVING:
			left_store.emit(customer_id, true)
			queue_free()

func _go_to_checkout() -> void:
	# Set nav target to checkout position
	# Placeholder:
	# nav_agent.target_position = Vector3(5, 0, 5)
	pass
