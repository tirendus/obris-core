extends StaticBody2D
class_name HarvestableResource

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var damageable: Damageable = $Damageable
@onready var mouse_over_area_2d: Area2D = $MouseOverArea2D
@onready var overlay := preload("res://scenes/crosshair_overlay.tscn")
const PickupScene = preload("res://scenes/pickup.tscn")

var drops := []

var crosshair_instance: Node2D = null

var on_death_timer := 0.15
var max_hp: int
var current_hp: int
var is_hovered := false

func _ready() -> void:
	damageable.max_hp = max_hp
	damageable.current_hp = current_hp
	damageable.damaged.connect(_on_damaged)

func mouse_hovered():
	is_hovered = true
	Globals.player.resource_focused(self)
	var res = Globals.player.harvesting_resource
	if not crosshair_instance and res == self:
		crosshair_instance = overlay.instantiate()
		add_child(crosshair_instance)
		var sprite_size = sprite_2d.texture.get_size()
		crosshair_instance.position = sprite_2d.position - sprite_size / 2
		crosshair_instance.size = sprite_2d.texture.get_size()
		
func mouse_unhovered():
	if not is_hovered: return
	is_hovered = false
	if crosshair_instance:
		crosshair_instance.queue_free()
		crosshair_instance = null
	Globals.player.resource_unfocused(self)

func _physics_process(delta: float) -> void:
	#if sprite_2d.get_rect().has_point(to_local(get_global_mouse_position())):
	if Globals.player.harvesting_resource != self and crosshair_instance:
		crosshair_instance.queue_free()
		crosshair_instance = null
	if damageable.is_dead():
		on_death_timer -= delta
	if on_death_timer <= 0:
		queue_free()
		spawn_pickups()
		Globals.player.harvesting_resource = null

func _on_damaged() -> void:
	var original_scale := sprite_2d.scale
	var tween := create_tween()
	# Stretch
	tween.tween_property(
		sprite_2d,
		"scale",
		Vector2(original_scale.x * 1.4, original_scale.y * 0.7),
		0.05
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		sprite_2d,
		"scale",
		original_scale,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func spawn_pickups():
	for drop in drops:
		var drop_count = drop.get_random_amount()
		for i in range(drop_count):
			var pickup = PickupScene.instantiate() as Pickup
			pickup.pickup_name = drop.pickup_name
			
			var sprite = pickup.get_node("Sprite2D")
			sprite.texture = drop.pickup

			# Random offset around the rock
			var offset = Vector2(
				randf_range(-16, 16),
				randf_range(-16, 16)
			)

			pickup.global_position = global_position + offset
			get_tree().current_scene.add_child(pickup)
