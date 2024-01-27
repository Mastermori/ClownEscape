extends RayCast3D


@onready var beam_mesh = $BeamMesh
@onready var hit_particles = $HitParticles
@onready var beam_particles = $BeamParticles


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var cast_point
	force_raycast_update()
	
	if is_colliding():
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		hit_particles.position.y = cast_point.y
		
		beam_particles.position.y = cast_point.y/2
		beam_particles.process_material.set_emission_box_extents(
			Vector3(beam_mesh.mesh.top_radius, abs(cast_point.y)/2, beam_mesh.mesh.bottom_radius)
		)
