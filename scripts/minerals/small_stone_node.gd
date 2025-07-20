extends HarvestableResource


func _ready() -> void:
	max_hp = 3
	current_hp = 3
	drops = Globals.DROP_TABLE[Globals.STONE_NODE]
	super._ready()
