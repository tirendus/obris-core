extends Node

var player: Player = null

# Resource definitions
const STONE_NODE = 'stone_node'
const IRON_NODE = 'iron_node'
const TREE_NODE = 'tree_node'

# Pickup definitions
const STONE_PICKUP = 'stone_pickup'
const IRON_PICKUP = 'iron_pickup'
const WOOD_PICKUP = 'wood_pickup'

const PICKUP_SCENES = {
	STONE_PICKUP: preload("res://assets/minerals/stone_pickup.png"),
	IRON_PICKUP: preload("res://assets/minerals/iron_pickup.png"),
	WOOD_PICKUP: preload("res://assets/trees/wood_pickup.png"),
}

var DROP_TABLE := {
	# (PICKUP_SCENE, DROP_CHANCE, MIN, MAX)
	STONE_NODE: [DropEntry.new().setup(PICKUP_SCENES[STONE_PICKUP], 1.0, 3, 4, STONE_PICKUP)],
	IRON_NODE: [DropEntry.new().setup(PICKUP_SCENES[IRON_PICKUP], 1.0, 2, 3, IRON_PICKUP)],
	TREE_NODE: [DropEntry.new().setup(PICKUP_SCENES[WOOD_PICKUP], 1.0, 3, 4, WOOD_PICKUP)],
}

#func get_modified_drop_table(node_type: String) -> Array[DropEntry]:
	#var base_drops = DROP_TABLE.duplicate()
	#var modified_drops: Array[DropEntry] = []
#
	#for drop in base_drops.get(node_type, []):
		#var modified = drop.duplicate()
		##if node_type == IRON_NODE and player.has_upgrade("more_iron"):
			##modified.min = 3
			##modified.max = 3
		#modified_drops.append(modified)
	#return modified_drops
