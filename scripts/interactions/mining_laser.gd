extends Line2D
class_name MiningLaser

@export var wave_amplitude := 2.0
@export var wave_frequency := 20.0
@export var point_count := 20

var time := 0.0
var from := Vector2.ZERO
var to := Vector2.ZERO

func _ready():
	clear_points()
	width = 3.0
	default_color = Color.CRIMSON

func setup(p_from: Vector2, p_to: Vector2) -> void:
	from = p_from
	to = p_to
	_update_laser()

func _process(delta: float) -> void:
	time += delta
	_update_laser()

func _update_laser():
	var line = self
	line.clear_points()

	var dir = to - from
	var length = dir.length()
	var normal = dir.normalized().orthogonal()

	for i in range(point_count):
		var t = float(i) / float(point_count - 1)
		var point_pos = from.lerp(to, t)

		var wave = sin(time * 20.0 + t * wave_frequency) * wave_amplitude
		point_pos += normal * wave

		line.add_point(point_pos)
		if has_node("BeamParticles"):
			var beam_particles = $BeamParticles
			var direction = to - from
			var angle = direction.angle()

			beam_particles.position = to
			beam_particles.rotation = angle  # ← THIS aligns emission direction

			var dist = direction.length()
			var mat = beam_particles.process_material as ParticleProcessMaterial
			if mat:
				mat.emission_box_extents = Vector3(dist / 2, 1, 0)
