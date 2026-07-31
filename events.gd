extends Node


@warning_ignore_start("unused_signal")

signal entity_hovered (entity: Entity)
signal entity_controlled (entity: Entity)
signal entity_selected (entity: Entity)

signal projectile_spawn_requested (projectile: Projectile)

#signal particle_spawn_requested (particle: Node2D, position: Vector2)
signal particle_spawn_requested (particle_scene: PackedScene, position: Vector2)

signal audio_requested (stream: AudioStream)
signal audio_2d_requested (stream: AudioStream, position: Vector2)
