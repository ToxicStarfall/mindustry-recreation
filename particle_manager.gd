@tool
extends Node2D


var queue: Array



func _ready() -> void:
	if !Engine.is_editor_hint():
		Events.particle_spawn_requested.connect( _on_particle_spawn_requested )
	pass


#func _on_particle_spawn_requested(particle_scene_path: String, spawn_position: Vector2):
func _on_particle_spawn_requested(particle_scene: PackedScene, spawn_position: Vector2, spawn_rotation: float = 0.0):
	#var particle = load(particle_scene_path).instantiate()
	var particle = particle_scene.instantiate()
	particle.position = spawn_position
	if particle.name == "SmokeParticles": particle.position.y -= particle.emission_rect_extents.y / 2  # Adjust pos for smoke emission rect centerD.
	particle.rotation = spawn_rotation
	particle.z_index = 1
	
	add_child(particle)
	particle.emitting = true
	
	await particle.finished
	particle.queue_free()
	pass
