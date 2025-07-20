extends StaticBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var damageable: Damageable = $Damageable
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@export var pickup_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
