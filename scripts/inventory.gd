extends Node

class_name Inventory

var items := {}

func add_item(item_name: String, amount: int = 1) -> void:
	if items.has(item_name):
		items[item_name] += amount
	else:
		items[item_name] = amount
	print('iron ore', items['iron_ore'])

func remove_item(item_name: String, amount: int = 1) -> void:
	if items.has(item_name):
		items[item_name] -= amount
		if items[item_name] <= 0:
			items.erase(item_name)

func has_item(item_name: String, amount: int = 1) -> bool:
	return items.get(item_name, 0) >= amount
