@tool
@icon("res://assets/icons/ranged_weapon.svg")
class_name RangedWeapon
extends Weapon


#@export_group("Testing")
signal test_fired

@export_tool_button("Test Fire") var test_fire_button = _test_fire
@export var auto_fire: bool = false: set = _set_auto_fire
@export var auto_fire_interval: float = 1.0

@export_group("")


#@export_group("")
#@export_file(".") var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene: PackedScene = "res://entities/projectiles/"


@export_group("Projectile")
@export var projectile_scene: PackedScene
@export var lifetime: float = 1.0
@export var projectile_size: Vector2
@export var speed: float = 10.0
@export var damage: DamageComponent

@export_subgroup("Acceleration")
@export var acceleration: float
@export var accel_curve: float
#@export var drag: float

@export_subgroup("Trajectory")


@export_group("Ammo System")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var ammo_enabled: bool = false
@export var ammo: int = 60
@export var magazine: int = 20
@export var max_ammo: int = 0  # 

@export_group("Overheating")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var overheating_enabled: bool = false
@export var overheats: bool = false
@export var heat_threshold: float = 100.0
@export var heat_rate: float = 10.0
@export var cool_rate: float = 8.0

@export_group("Animation")
@export var recoil_dist: float = 10.0  ## Distance of recoil effect in pixels.

@export_group("Sounds")
@export var fire_sound: AudioStream
@export var reload_sound: AudioStream
#@export var charge: AudioStream
#@export var heatup_sound: AudioStream
#@export var cooldown_sound: AudioStream

@export_group("Particles")
#@export var fire_particles: Array[Node2D]
#@export var fire_particles: Array[PackedScene]
@export var flash_particle: PackedScene = preload("res://effects/particles/flash_small.tscn")
@export var smoke_particle: PackedScene = preload("res://effects/particles/smoke_small.tscn")
#@export var particle_offset: Vector2

#@export_group("Toggles")
#@export var infinite_ammo: bool = false  ## Requires ammo system to be enabled.


#func _ready() -> void:
	#pass


#func _physics_process(delta: float) -> void:
	#pass


func attack():
	fire_projectile(targeted_position)


func fire_projectile(dir: Vector2):
	var projectile: Projectile = projectile_scene.instantiate()
	var projectile_spawn_pos: Vector2 = self.global_position if !has_node("Marker2D") else $Marker2D.global_position
	projectile.faction = self.owner.faction
	projectile.spawner_entity = self.owner
	projectile.damage_comp = damage_comp
	
	projectile.lifetime = lifetime
	projectile.scale_to(projectile_size)
	
	projectile.speed = speed
	projectile.direction = dir.normalized()
	projectile.position = projectile_spawn_pos
	projectile.rotation = dir.normalized().rotated(deg_to_rad(90)).angle()
	
	_animate_recoil()
	_spawn_particles(projectile_spawn_pos, projectile.rotation)
	
	Events.projectile_spawn_requested.emit( projectile )
	Events.audio_2d_requested.emit( fire_sound, self.global_position )


func _animate_recoil():
	if has_node("Sprite2D"):
		var tween = create_tween()
		var start_y = $Sprite2D.position.y
		tween.tween_property($Sprite2D, "position:y", start_y + recoil_dist, 0.10 * cooldown).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D, "position:y", start_y, 0.80 * cooldown).set_trans(Tween.TRANS_SINE)#.set_ease(Tween.EASE_IN)


func _spawn_particles(spawn_position = self.global_position, angle = 0.0):
	if flash_particle:
		Events.particle_spawn_requested.emit(flash_particle, spawn_position, angle)
	if smoke_particle:
		Events.particle_spawn_requested.emit(smoke_particle, spawn_position, angle)


# - - -  @TOOL FUNCTIONS  - - - #

## @tool utility function
func _set_auto_fire(value):
	auto_fire = value
	_auto_fire()


## @tool utility function
func _auto_fire():
	if auto_fire:
		if get_tree():
			_test_fire()
			await get_tree().create_timer( auto_fire_interval ).timeout
			_auto_fire()


## @tool utility function
func _test_fire():
	var dir = Vector2.from_angle(rotation).rotated(deg_to_rad(-90))
	
	var projectile: Projectile = projectile_scene.instantiate()
	#projectile.faction = self.owner.faction
	#projectile.spawner_entity = self.owner
	#projectile.damage_comp = damage_comp
	
	projectile.lifetime = lifetime
	projectile.scale_to(projectile_size)
	
	projectile.speed = speed
	projectile.direction = dir.normalized()
	projectile.position = self.global_position
	projectile.rotation = dir.normalized().rotated(deg_to_rad(90)).angle()
	
	_animate_recoil()
	_spawn_particles()
	test_fired.emit(projectile)
	
	#Events.projectile_spawn_requested.emit( projectile )
