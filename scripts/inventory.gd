extends Node

class_name Inventory

var items := {}

func add_item(item_name: String, amount: int = 1) -> void:
	if items.has(item_name):
		items[item_name] += amount
	else:
		items[item_name] = amount
	var format_string = "Stone: {stone}. Iron: {iron}. Wood: {wood}."
	Globals.player.get_node("Label").text = format_string.format({
		"stone": str(items.get(Globals.STONE_PICKUP, 0)),
		"iron": str(items.get(Globals.IRON_PICKUP, 0)),
		"wood": str(items.get(Globals.WOOD_PICKUP, 0)),
	})

func remove_item(item_name: String, amount: int = 1) -> void:
	if items.has(item_name):
		items[item_name] -= amount
		if items[item_name] <= 0:
			items.erase(item_name)

func has_item(item_name: String, amount: int = 1) -> bool:
	return items.get(item_name, 0) >= amount
