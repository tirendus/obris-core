extends HarvestableResource


func _ready() -> void:
	max_hp = 4
	current_hp = 4
	drops = Globals.DROP_TABLE[Globals.IRON_NODE]
	super._ready()
