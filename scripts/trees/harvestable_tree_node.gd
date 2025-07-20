extends HarvestableResource


func _ready() -> void:
	max_hp = 7
	current_hp = 7
	drops = Globals.DROP_TABLE[Globals.TREE_NODE]
	super._ready()
