class_name DropEntry
extends Resource

var pickup: Resource
var pickup_name: String
var drop_rate: float
var min_dropped_items: int
var max_dropped_items: int

func setup(_pickup: Resource, _drop_rate: float, _min: int, _max: int, _pickup_name: String) -> DropEntry:
	self.pickup = _pickup
	self.drop_rate = _drop_rate
	self.min_dropped_items = _min
	self.max_dropped_items = _max
	self.pickup_name = _pickup_name
	return self

func get_random_amount() -> int:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if rng.randf() > drop_rate:
		return 0
	return rng.randi_range(min_dropped_items, max_dropped_items)
