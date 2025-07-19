extends CharacterBody2D


const SPEED := 250.0
@onready var animation: AnimatedSprite2D = $animation
var last_direction := Vector2.DOWN

const DASH_SPEED = 800.0
const DASH_DURATION = 0.15
const DASH_COOLDOWN = 0.4
var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var is_dashing := false

@export var dash_after_image: PackedScene

# Stats
var attack_speed := 2
var attack_cooldown_timer := 0.0
var is_attacking := false
var damage := 1

# Interactables
var nearby_mineable_resource: StaticBody2D = null

func _physics_process(delta: float) -> void:
	# Move
	var input_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	velocity = input_vector * SPEED
	
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
	# TODO: Fix building interaction
	# TODO: Attack direction
	if attack_cooldown_timer > 0:
		attack_cooldown_timer -= delta
	if Input.is_action_just_pressed("action") and attack_cooldown_timer <= 0:
		perform_attack()

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
	afterimage.global_position = global_position
	
	var frame_texture = animation.sprite_frames.get_frame_texture(animation.animation, animation.frame)
	afterimage.texture = frame_texture
	
	# Match visual settings
	afterimage.flip_h = animation.flip_h
	afterimage.scale = animation.scale
	afterimage.z_index = self.z_index - 1

	get_tree().current_scene.add_child(afterimage)


func _on_ready() -> void:
	Globals.player = self

func perform_attack():
	is_attacking = true
	var did_hit_something := false
	
	if nearby_mineable_resource != null:
		nearby_mineable_resource.apply_damage(damage)
		did_hit_something = true
	
	if did_hit_something:
		attack_cooldown_timer = 1.0 / attack_speed
