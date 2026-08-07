@tool
class_name Projectile
extends Area2D


@export_enum("none", "shard", "crux", "malis") var faction: String

@export var default_size: Vector2 = Vector2(20, 28)

@export_group("Sounds")
#@export var movement_sound: AudioStream
#@export var hit_sound: AudioStream
@export var despawn_sound: AudioStream

@export_group("Particles")
@export var despawn_particles: Array[PackedScene]

#@export var projectile: Texture2D
#@export var projectile_back: Texture2D
#@export var casing: Texture2D
#@export var falloff_curve: Curve
#@export var spread: float
#@export var casing_speed: float
#@export_range(-180.0, 180.0) var casing_angular_speed: float = -30.0

var lifetime: float = 1.0  ## Projectile lifeitme in seconds.
var speed: float = 10.0  ## Projectile speed in tiles/second.
var direction: Vector2

var damage_comp: DamageComponent

var spawner_entity: Entity



func _init() -> void:
	if !Engine.is_editor_hint():
		faction = Factions.NONE.id
	pass
	

func _ready() -> void:
	if get_tree().edited_scene_root != self:
		get_tree().create_timer(lifetime).timeout.connect( _on_lifetime_timeout )


func _physics_process(_delta: float) -> void:
	self.position += direction * speed


func collided():
	# Do things after having collided with an object
	self.queue_free()


func scale_to(size: Vector2 = default_size):
	if size != Vector2.ZERO:
		#print(scale, " to ", (size / default_size))
		scale = (size / default_size)
	pass


func _on_lifetime_timeout():
	queue_free()
	for particle in despawn_particles:
		Events.particle_spawn_requested.emit(particle, self.global_position)
	#Events.particle_spawn_requested.emit("res://effects/particles/blast_particles.tscn", self.position)
	#Events.particle_spawn_requested.emit("res://effects/particles/blast_wave_particle.tscn", self.position)
