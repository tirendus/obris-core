extends StaticBody2D

@onready var area_2d: Area2D = $Area2D
@onready var popup: Panel = $Popup
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var pickup_scene: PackedScene

var max_hp := 3
var current_hp: int

#TODO: Expand to load resources dynamically
func _ready() -> void:
	current_hp = max_hp
	popup.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		popup.visible = true
		Globals.player.nearby_mineable_resource = self


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		popup.visible = false
		Globals.player.nearby_mineable_resource = null

func handle_attacked():
	var original_color := animated_sprite_2d.self_modulate
	var original_scale := animated_sprite_2d.scale
	animated_sprite_2d.self_modulate = Color(2, 2, 2, 1)  # overbright flash

	var tween := create_tween()
	# Flash
	tween.tween_property(animated_sprite_2d, "self_modulate", original_color, 0.1)
	# Stretch
	tween.tween_property(
		animated_sprite_2d,
		"scale",
		Vector2(original_scale.x * 1.2, original_scale.y * 0.8),
		0.05
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		animated_sprite_2d,
		"scale",
		original_scale,
		0.1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func apply_damage(amount: int) -> void:
	current_hp -= amount
	handle_attacked()
	if current_hp <= 0:
		# TODO: Disappears immediately on last hit, wait for the animation to finish
		spawn_pickups()
		queue_free()

func spawn_pickups():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var drop_count := rng.randi_range(2, 4)
	for i in range(drop_count):
		var pickup = pickup_scene.instantiate() as Area2D

		# Random offset around the rock
		var offset = Vector2(
			randf_range(-16, 16),
			randf_range(-16, 16)
		)

		pickup.global_position = global_position + offset
		get_tree().current_scene.add_child(pickup)


	
