extends StaticBody2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var damageable: Damageable = $Damageable
@onready var overlay := preload("res://scenes/crosshair_overlay.tscn")

const PickupScene = preload("res://scenes/pickup.tscn")
const RESOURCE_ICONS = {
	"stone_pickup": preload("res://assets/minerals/stone_pickup.png"),
	"iron_pickup": preload("res://assets/minerals/iron_pickup.png"),
}

var crosshair_instance: Node2D = null
@export var resource_type: String = "stone_pickup"

var on_death_timer := 0.15

func _on_area_2d_mouse_entered():
	if crosshair_instance: return
	crosshair_instance = overlay.instantiate()
	add_child(crosshair_instance)
	var sprite_size = sprite_2d.texture.get_size()
	crosshair_instance.position = sprite_2d.position - sprite_size / 2
	crosshair_instance.size = sprite_2d.texture.get_size()

func _on_area_2d_mouse_exited():
	if crosshair_instance:
		crosshair_instance.queue_free()
		crosshair_instance = null

func _ready() -> void:
	damageable.max_hp = 2
	damageable.current_hp = 2
	damageable.damaged.connect(_on_damaged)


func _physics_process(delta: float) -> void:
	if damageable.is_dead():
		on_death_timer -= delta
	if on_death_timer <= 0:
		queue_free()
		spawn_pickups()

func handle_attacked():
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

func _on_damaged() -> void:
	handle_attacked()

func spawn_pickups():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var drop_count := rng.randi_range(2, 4)
	for i in range(drop_count):
		var pickup = PickupScene.instantiate() as Area2D
		
		var sprite = pickup.get_node("Sprite2D")
		sprite.texture = RESOURCE_ICONS.get(resource_type, null)

		# Random offset around the rock
		var offset = Vector2(
			randf_range(-16, 16),
			randf_range(-16, 16)
		)

		pickup.global_position = global_position + offset
		get_tree().current_scene.add_child(pickup)


	


func _on_mouse_entered() -> void:
	pass # Replace with function body.
