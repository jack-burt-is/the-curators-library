class_name PurchasedItems
extends Resource

@export var items: Array[Purchasable]

func add_item(item) -> void:
	items.append(item)
	
func get_items() -> Array[Purchasable]:
	return items
