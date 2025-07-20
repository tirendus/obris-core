extends Node2D


var last_hovered = null

func _process(_delta):
	var space_state = get_world_2d().direct_space_state
	var mouse_pos = get_global_mouse_position()

	var params = PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.collision_mask = 0xFFFFFFFF

	var results = space_state.intersect_point(params, 32)

	var new_hovered = null
	for hit in results:
		if hit.collider and hit.collider.is_in_group("harvestables"):
			new_hovered = hit.collider
			break

	if new_hovered != last_hovered:
		if last_hovered and last_hovered.has_method("mouse_unhovered"):
			last_hovered.mouse_unhovered()
		if new_hovered and new_hovered.has_method("mouse_hovered"):
			new_hovered.mouse_hovered()

	last_hovered = new_hovered
