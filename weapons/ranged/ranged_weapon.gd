@tool
@icon("res://assets/icons/ranged_weapon.svg")
class_name RangedWeapon
extends Weapon


signal test_fired

@export_tool_button("Test Fire") var test_fire_button = _test_fire
@export var auto_fire: bool = false: set = _set_auto_fire
@export var auto_fire_interval: float = 1.0

@export_group("")
#@export_file(".") var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene: PackedScene = "res://entities/projectiles/"

@export_group("Projectile")
@export var projectile_config = ProjectileConfig
@export var projectile_scene: PackedScene
@export var lifetime: float = 1.0
@export var projectile_size: Vector2
@export var speed: float = 10.0
@export var deviation: float = 0.0
@export var movement_pattern: MovementPattern
@export var mods: Array[ProjectileMod]


@export_subgroup("Acceleration")
@export var acceleration: float
@export var accel_curve: Curve
#@export var drag: float

@export_subgroup("Trajectory")
@export var arcing: bool = false  ## If true, the projectile only hits the targeted position at the end of the arc.


@export_group("Ammo System")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var ammo_enabled: bool = false
@export var ammo: int = 60
@export var max_ammo: int = 0  # 
#@export var infinite_ammo: bool = false  ## Requires ammo system to be enabled.
@export_subgroup("Magazines")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var magazines_enabled: bool = false
@export var magazine: int = 20
@export var max_magazine: int = 0  # 

@export_group("Overheating")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var overheating_enabled: bool = false
@export var overheats: bool = false
@export var heat_threshold: float = 100.0
@export var heat_rate: float = 20.0
@export var cool_rate: float = 10.0

@export_group("Animation")
@export var recoil_dist: float = 10.0  ## Distance of recoil effect in pixels.
#@export var recoil_max: float = 10.0  ## Distance of recoil effect in pixels.

@export_group("Sounds")
@export var fire_sound: AudioStream
@export var reload_sound: AudioStream
#@export var charge_sound: AudioStream
#@export var heatup_sound: AudioStream
#@export var cooldown_sound: AudioStream

@export_group("Particles")
#@export var fire_particles: Array[PackedScene]
@export var flash_particle: PackedScene = preload("res://effects/particles/flash_small.tscn")
@export var smoke_particle: PackedScene = preload("res://effects/particles/smoke_small.tscn")
#@export var particle_offset: Vector2

#@export_group("Toggles")


#func _ready() -> void:
	#pass


func _physics_process(_delta: float) -> void:
	if attacking:
		if !in_cooldown:
			# Fires projectiles when current rotation is pointing in direction of aim within a certain margin.
			#if rotation == angle or abs(rotation - angle) < deg_to_rad(aim_margin_degrees):
				in_cooldown = true
				
				for i in burst:
					fire_projectile(self.targeted_position - self.global_position)
					if burst_series and burst > 1:
						await get_tree().create_timer(burst_cooldown).timeout

				await get_tree().create_timer(cooldown).timeout
				in_cooldown = false
	pass


func attack():
	for i in burst:
		fire_projectile(targeted_position)
		if burst_series and burst > 1:
			await get_tree().create_timer(burst_cooldown).timeout


func fire_projectile(dir: Vector2):
	var projectile: Projectile = projectile_scene.instantiate()
	var projectile_spawn_pos: Vector2 = self.global_position if !has_node("Marker2D") else $Marker2D.global_position
	projectile.faction = "none" if owner else owner.faction
	projectile.spawner_entity = self.owner
	projectile.spawner_velocity =  Vector2.ZERO if owner is Block else self.owner.velocity 
	projectile.damage_comp = damage_comp
	projectile.mods.assign( mods.map( func(mod: ProjectileMod): return mod.duplicate() ) )
	#projectile.mods.append(PiercingMod.new())
	
	projectile.lifetime = lifetime
	projectile.scale_to(projectile_size)
	
	projectile.speed = speed
	projectile.position = projectile_spawn_pos
	projectile.rotation = dir.normalized().rotated(PI/2).angle()
	
	var deviation_amount = randf_range(-deviation, deviation)
	projectile.rotation = projectile.rotation + deg_to_rad(deviation_amount)  # Add projectile deviaion
	projectile.direction = dir.normalized().rotated( deg_to_rad(deviation_amount) )
	
	_animate_recoil()
	_animate_heat()
	_spawn_particles(projectile_spawn_pos, projectile.rotation)
	
	Events.projectile_spawn_requested.emit( projectile )
	Events.audio_2d_requested.emit( fire_sound, self.global_position )


func _animate_recoil():
	if has_node("Sprite2D"):
		var tween = create_tween()
		#var start_y = $Sprite2D.position.y
		var start_y = 0
		tween.tween_property($Sprite2D, "position:y", start_y + recoil_dist, 0.10 * cooldown).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D, "position:y", start_y, 0.80 * cooldown).set_trans(Tween.TRANS_SINE)#.set_ease(Tween.EASE_IN)


func _animate_heat():
	if has_node("%Heat"):
		var tween = create_tween()
		tween.tween_property(%Heat, "modulate", Color("ab3400ff", 0.5), 0.20 * cooldown).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(%Heat, "modulate", Color("ab3400ff", 0.0), 0.60 * cooldown).set_trans(Tween.TRANS_SINE)


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
		pass
		#if get_tree():
			#_test_fire()
			#await get_tree().create_timer( auto_fire_interval ).timeout
			#_auto_fire()


## @tool utility function
func _test_fire():
	for i in burst:
		var dir = Vector2.from_angle(rotation).rotated( -(PI/2) )
		
		var projectile: Projectile = projectile_scene.instantiate()
		var projectile_spawn_pos: Vector2 = self.global_position if !has_node("Marker2D") else $Marker2D.global_position
		projectile.faction = "none"
		#projectile.spawner_entity = self.owner
		#projectile.damage_comp = damage_comp
		
		projectile.lifetime = lifetime
		projectile.scale_to(projectile_size)
		
		var deviation_amount = randf_range(-deviation, deviation)
		projectile.speed = speed
		projectile.direction = dir.normalized().rotated( deg_to_rad(deviation_amount) )
		projectile.position = projectile_spawn_pos
		projectile.rotation = dir.normalized().rotated(PI/2).angle()
		projectile.rotation = projectile.rotation + deg_to_rad(deviation_amount)  # Add projectile deviaion
		
		_animate_recoil()
		#_spawn_particles()
		test_fired.emit(projectile)
		
		#Events.projectile_spawn_requested.emit( projectile )

		if burst_series and burst > 1:  # Delay between projectiles in a burst.
			await get_tree().create_timer(burst_cooldown).timeout
