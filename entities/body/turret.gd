#class_name Turret2
#extends Node2D
#
#
##@export var ammo: int = 60
##@export var magazine: int = 20
##@export var max_ammo: int = 0  # 
#@export var aim_margin_degrees: float = 1.0  ## 
#@export var rotation_speed: float = 90.0  ## Turret rotation speed in degrees.
#@export var smart_aiming: bool = true  ## Enables aiming prediction.
#
##@export_file(".") var projectile_scene: PackedScene
##@export_file("*.tscn") var projectile_scene: String = "res://scenes/enemies/"
#@export var projectile_scene: PackedScene
#@export var damage_comp: DamageComponent
#@export var delay: float = 0.5
#@export var cooldown: float = 1.0
#
#@export_subgroup("Animation")
#@export var recoil_dist: float = 10.0  ## Distance of recoil effect in pixels.
#
#
#var attacking: bool = false
#var in_cooldown: bool = false
#
#
#func _physics_process(delta: float) -> void:
	#if attacking:
		#var mouse_pos = get_global_mouse_position()
		#var angle = rotation + get_angle_to(mouse_pos)
		#rotation = rotate_toward(rotation, angle, delta * deg_to_rad(rotation_speed))  # NOTE: rotate_towards() uses radians.
		#
		#if !in_cooldown:
			#if rotation == angle or abs(rotation - angle) < deg_to_rad(aim_margin_degrees):
				#in_cooldown = true
				#fire_projectile(mouse_pos - self.global_position, get_angle_to(mouse_pos))
				#await get_tree().create_timer(cooldown).timeout
				#in_cooldown = false
		#
#
#func fire_projectile(dir: Vector2, angle):
	#var projectile: Projectile = projectile_scene.instantiate()
	#projectile.faction = get_parent().get_parent().faction
	#projectile.damage_comp = damage_comp
	#projectile.direction = dir.normalized()
	#projectile.position = self.global_position
	#projectile.rotation = dir.normalized().rotated(deg_to_rad(90)).angle()	
	#_animate_recoil()
	#
	#Events.projectile_spawned.emit( projectile )
#
#
#func _animate_recoil():
	#if has_node("Sprite2D"):
		#var tween = create_tween()
		#tween.tween_property($Sprite2D, "position:x", position.x - recoil_dist, 0.10 * cooldown).set_trans(Tween.TRANS_SINE)
		#tween.tween_property($Sprite2D, "position:x", position.x, 0.80 * cooldown).set_trans(Tween.TRANS_SINE)#.set_ease(Tween.EASE_IN)
