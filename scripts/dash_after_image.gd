extends Sprite2D


func _on_ready() -> void:
	modulate = Color(0.8, 0.5, 1.0, 0.6)  # Light purple with some transparency
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.25)
	tween.tween_callback(Callable(self, "queue_free"))
