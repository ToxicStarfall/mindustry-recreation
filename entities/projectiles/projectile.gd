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
var speed: float = 5.0  ## Projectile speed in tiles/second.
var direction: Vector2  ## The movement direction of this projectile.

var trail_threshold: float = 8.0

var damage_comp: DamageComponent
var mods: Array[ProjectileMod]

# Projectile modifiers callback handle checks
var collision_handled: bool = false
var despawn_handled: bool = false
var timeout_handled: bool = false


var spawner_entity: Entity
var spawner_velocity: Vector2  ## The movement velocity of the spawner entity. (added to projectile final velocity)


func _init() -> void:
	if !Engine.is_editor_hint():
		faction = Factions.NONE.id
	

func _ready() -> void:
	if get_tree().edited_scene_root != self:
		get_tree().create_timer(lifetime).timeout.connect( _on_lifetime_timeout )
		
		for mod in mods: mod.call(&"spawned", self)
		


func _process(_delta: float) -> void:
	if speed > trail_threshold * Game.TILE_SIZE:
	#if speed >= trail_threshold:
		$Trail.show()
		#$Trail.set_point_position(1, Vector2(0, speed * Game.TILE_SIZE))
		pass


func _physics_process(delta: float) -> void:
	#self.position += (direction * speed)
	self.position += (direction * speed) + ((spawner_velocity / 2) * delta)  # NOTE - spawner_vel / 2 to reduce speed issues
	pass


func collided():
	# TODO - Figure out callback to mods to know it it handles freeing.
	for mod in mods: mod.call(&"collided", self)
	
	#if !despawn_handled:
	## Do things after having collided with an object
	if !is_queued_for_deletion():
		self.queue_free()
	pass


func scale_to(size: Vector2 = default_size):
	if size != Vector2.ZERO:
		#print(scale, " to ", (size / default_size))
		scale = (size / default_size)
	pass


func _on_lifetime_timeout():
	#if despawn_handled
	for mod in mods: mod.call(&"despawned", self)
	queue_free()
	for particle in despawn_particles:
		Events.particle_spawn_requested.emit(particle, self.global_position)
