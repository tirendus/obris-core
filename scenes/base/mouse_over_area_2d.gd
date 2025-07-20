extends Area2D

@onready var parent_resource := get_parent() as HarvestableResource

func _ready() -> void:
	self.add_to_group("harvestables")

func mouse_hovered():
	if parent_resource:
		parent_resource.mouse_hovered()

func mouse_unhovered():
	if parent_resource:
		parent_resource.mouse_unhovered()
