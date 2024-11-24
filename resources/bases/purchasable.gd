class_name Purchasable
extends Resource

## The name of the item
@export var name: String

## The cost in coins of the purchasable
@export var cost: int

## What category is the item
@export var category: ShopEnums.Category

## The icon to display in the shop
@export var texture: Texture

func _to_string() -> String:
	return name
