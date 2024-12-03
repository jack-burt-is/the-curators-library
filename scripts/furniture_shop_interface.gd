extends Control

@onready var purchasables = Helpers.load_all_resources("res://resources/purchasables/")
@onready var furniture_list: GridContainer = %FurnitureList
@onready var cart_items: VBoxContainer = $VBoxContainer/Body/CartContainer/VBoxContainer/MarginContainer/Cart/ScrollContainer/CartItems
@onready var subtotal_value: Label = $VBoxContainer/Body/CartContainer/VBoxContainer/MarginContainer/Cart/SubtotalLabel

var shop_item = preload("res://scenes/shop_item.tscn")
var cart_item = preload("res://scenes/cart_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reload_items()

func reload_items() -> void:
	# Clear list first
	var children = furniture_list.get_children()
	for child in children:
		child.free()

	for item in purchasables:
		if item.category == ShopEnums.Category.FURNITURE:
			# Don't show anything we've already bought
			if GameManager.data.purchased_items.items.has(item):
				break
				
			# Create instance in shop
			var shop_item_instance = shop_item.instantiate()
			furniture_list.add_child(shop_item_instance)
			shop_item_instance.init_item(item)
			shop_item_instance.add_item_to_cart.connect(_add_furniture_to_cart)

func _add_furniture_to_cart(item: Purchasable):
	if cart_items.get_child_count() > 0:
		for existing_item in cart_items.get_children():
			if existing_item.item == item:
				return
			
	var cart_item_instance = cart_item.instantiate()
	cart_items.add_child(cart_item_instance)
	cart_item_instance.init_cart_item(item)
	refresh_subtotal()

func _on_purchase_pressed() -> void:
	var total_cost = int(subtotal_value.text)
	
	if total_cost > GameManager.data.coins:
		# Reject purchase, insufficient funds
		print ("Too poor")
		return
	
	GameManager.data.coins -= total_cost
	
	# Clear cart
	var children = cart_items.get_children()
	if children.size() > 0:
		# Play sound
		GameManager.play_purchased_sound()
		
		for child in children:
			GameManager.data.purchased_items.add_item(child.item)
			child.free()
		
	reload_items()
	refresh_subtotal()

func refresh_subtotal(node: Node = null):
	var total_value = 0
	
	# Clear cart
	var children = cart_items.get_children()
	for child in children:
		if not node or not child == node:
			total_value += child.item.cost
		
	subtotal_value.text = str(total_value)


func _on_cart_items_child_exiting_tree(node: Node) -> void:
	refresh_subtotal(node)
