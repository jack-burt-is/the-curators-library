class_name PurchasableNode
extends Node2D

var purchasable_resource: Purchasable

func init_purchasable(resource: Purchasable):
	purchasable_resource = resource
	GameManager.new_day_started.connect(handle)
	handle()
	
func handle():
	if GameManager.data.purchased_items.items.has(purchasable_resource):
		show()
	else:
		hide()
