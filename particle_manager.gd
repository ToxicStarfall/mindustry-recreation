@tool
extends Node2D


var queue: Array



func _ready() -> void:
	if !Engine.is_editor_hint():
		Events.particle_spawn_requested.connect( _on_particle_spawn_requested )
	pass


func _on_particle_spawn_requested(particle_scene_path: String, spawn_position: Vector2):
	var particle = load(particle_scene_path).instantiate()
	particle.position = spawn_position
	add_child(particle)
	particle.emitting = true
	pass
