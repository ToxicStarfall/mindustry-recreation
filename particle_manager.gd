@tool
extends Node2D


var queue: Array



func _ready() -> void:
	if !Engine.is_editor_hint():
		Events.particle_spawn_requested.connect( _on_particle_spawn_requested )
	pass


func _on_particle_spawn_requested(particle_scene: PackedScene, spawn_position: Vector2, spawn_rotation: float = 0.0):
	#var particle = load(particle_scene_path).instantiate()
	var particle = particle_scene.instantiate()
	particle.position = spawn_position
	
	if particle.name == "SmokeParticles":
		# Adjust spawn position for smoke emission rect center by half of its length.
		particle.position += Vector2.from_angle(spawn_rotation).rotated(-PI / 2) * (particle.emission_rect_extents.y / 2)
	
	particle.rotation = spawn_rotation
	particle.z_index = 1
	
	add_child(particle)
	particle.emitting = true
	
	await particle.finished
	particle.queue_free()
	pass
