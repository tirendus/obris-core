extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var vacuuming := false
var target: Node2D = null
var speed := 200.0
var pickup_radius := 10.0

var velocity := Vector2.ZERO
var landed := false
var ground_y := 0.0
var can_be_collected := false

func _ready() -> void:
	# Initial random launch
	ground_y = global_position.y + randf_range(8, 20)
	velocity = Vector2(randf_range(-100, 100), randf_range(-250, -150))

	# Disable collision until landed
	collision_shape_2d.disabled = true
	monitoring = true

func _physics_process(delta: float) -> void:
	if vacuuming and target:
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta

		if global_position.distance_to(target.global_position) <= pickup_radius:
			_on_reach_player()

	if not landed:
		velocity.y += gravity * delta
		global_position += velocity * delta

		if global_position.y >= ground_y:
			global_position.y = ground_y
			velocity = Vector2.ZERO
			landed = true
			start_pickup_delay()

func start_pickup_delay() -> void:
	await get_tree().create_timer(0.2).timeout
	collision_shape_2d.disabled = false
	can_be_collected = true
	monitoring = true  # Enable area detection again

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not vacuuming and can_be_collected:
		vacuuming = true
		target = body
		set_deferred("monitoring", false)
		set_collision_layer(0)
		set_collision_mask(0)
	

func _on_reach_player() -> void:
	# Add to inventory or similar logic here
	PlayerInventory.add_item('iron_ore')
	queue_free()
