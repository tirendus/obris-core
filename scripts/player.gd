extends CharacterBody2D
class_name Player

const LaserBeam = preload("res://scenes/player/mining_laser.tscn")
@onready var animation: AnimatedSprite2D = $animation
@onready var attack_range: Area2D = $AttackRange

# Movement
const SPEED := 150.0
const DASH_SPEED = SPEED * 3
const DASH_DURATION = 0.167
const DASH_COOLDOWN = 0.4
var last_direction := Vector2.DOWN
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var is_dashing := false
@export var dash_after_image: PackedScene

# Stats
var attacks_per_second := 2
var attack_cooldown_timer := 0.0
var damage := 1

# Interactables
var harvesting_resource: HarvestableResource = null
var mining_laser: MiningLaser = null

func _physics_process(delta: float) -> void:
	# Move
	var input_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = input_vector * SPEED
	
	if mining_laser and harvesting_resource and _is_in_attack_range(harvesting_resource):
		var start_pos = global_position
		var end_pos = harvesting_resource.get_node("CollisionShape2D").global_position
		mining_laser.setup(start_pos, end_pos)
	elif mining_laser:
		mining_laser.queue_free()
		mining_laser = null
	
	# Dash
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0:
		start_dash()
	if is_dashing:
		velocity = last_direction.normalized() * DASH_SPEED
		dash_timer -= delta
		spawn_afterimage()
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown_timer = DASH_COOLDOWN
	
	move_and_slide()
	
	# Animate character
	if input_vector != Vector2.ZERO:
		last_direction = input_vector
		_play_walk_animation(input_vector)
	else:
		_play_idle_animation(last_direction)
	
	# Attacks
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta
	if Input.is_action_pressed("attack") and attack_cooldown_timer <= 0:
		perform_attack()
	if (!harvesting_resource or Input.is_action_just_released("attack")) and mining_laser:
		mining_laser.queue_free()
		mining_laser = null

func _play_walk_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		animation.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		animation.play("walk_down" if dir.y > 0 else "walk_up")

func _play_idle_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		animation.play("idle_right" if dir.x > 0 else "idle_left")
	else:
		animation.play("idle_down" if dir.y > 0 else "idle_up")

func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION
	spawn_afterimage()

func spawn_afterimage():
	var afterimage = dash_after_image.instantiate() as Sprite2D
	var frame_texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	afterimage.texture = frame_texture
	afterimage.global_position = global_position
	afterimage.flip_h = animation.flip_h
	afterimage.scale = animation.scale
	get_tree().current_scene.add_child(afterimage)

func _ready() -> void:
	Globals.player = self
	
func _is_in_attack_range(body_to_check: Node2D):
	var overlapping = attack_range.get_overlapping_bodies()
	return harvesting_resource in overlapping

func perform_attack():
	var did_hit_something := false
	
	if harvesting_resource != null and _is_in_attack_range(harvesting_resource):
		harvesting_resource.damageable.apply_damage(damage)
		did_hit_something = true
		if mining_laser == null:
			mining_laser = LaserBeam.instantiate()
			get_tree().current_scene.add_child(mining_laser)
		
		var start_pos = global_position
		var end_pos = harvesting_resource.get_node("CollisionShape2D").global_position
		mining_laser.setup(start_pos, end_pos)
	else:
		print("Target is out of range.")
		if mining_laser != null:
			mining_laser.queue_free()
			mining_laser = null
	
	# TODO: Fizzle animation and always cooldown
	if did_hit_something:
		attack_cooldown_timer = 1.0 / attacks_per_second

func resource_focused(resource: HarvestableResource):
	#if harvesting_resource == null or not Input.is_action_pressed("attack"):
	harvesting_resource = resource
	
func resource_unfocused(resource: HarvestableResource):
	if not Input.is_action_pressed("attack") and harvesting_resource == resource:
		harvesting_resource = null
