extends Node3D

@export var active: bool = true :
	set(val):
		active = val
		if not is_node_ready():
			return
		beam_mesh.visible = val
		hit_particles.visible = val
		beam_particles.visible = val
		set_physics_process(val)


@onready var beam_mesh = %BeamMesh
@onready var hit_particles = %HitParticles
@onready var beam_particles = %BeamParticles
@onready var ray = $Ray

func _ready():
	active = active

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var cast_point
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider is Player:
			Global.level.reset_player()
		cast_point = ray.to_local(ray.get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y/2
		
		hit_particles.position.y = cast_point.y
		
		beam_particles.position.y = cast_point.y/2
		beam_particles.process_material.set_emission_box_extents(
			Vector3(beam_mesh.mesh.top_radius, abs(cast_point.y)/2, beam_mesh.mesh.bottom_radius)
		)

func toggle():
	active = not active
