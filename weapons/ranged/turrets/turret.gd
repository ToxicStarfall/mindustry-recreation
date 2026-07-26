@tool
class_name Turret
extends RangedWeapon


@export var aim_margin_degrees: float = 1.0  ## 
@export var rotation_speed: float = 90.0  ## Turret rotation speed in degrees.
@export_range(0, 180.0) var rotation_limit_left: float = 0.0  ##
@export_range(0, 180.0)  var rotation_limit_right: float = 0.0  ##

@export var smart_aiming: bool = true  ## Enables aiming prediction.


@export_group("Sounds")
@export var rotation_sound: AudioStream


func _physics_process(delta: float) -> void:
	if owner is Unit and !owner.is_controlled:
		if targeted_entity:
			targeted_position = targeted_entity.global_position
			#print(targeted_entity.global_position)
	
	if attacking:
		#if get_parent() is WeaponGroup:
			#if rotation < rotation_limit_left and rotation > rotation_limit_right:
				#return
			
		var angle = rotation + get_angle_to(self.targeted_position)
		angle += deg_to_rad(90)
		
		rotation = rotate_toward(  # NOTE: rotate_towards() uses radians.
			rotation, 
			angle,
			delta * deg_to_rad(rotation_speed)
			)
		
		if !in_cooldown:
			# Fires projectiles when current rotation is pointing in direction of aim within a certain margin.
			if rotation == angle or abs(rotation - angle) < deg_to_rad(aim_margin_degrees):
				in_cooldown = true
				#fire_projectile(self.targeted_position - self.global_position, get_angle_to(self.targeted_position))
				fire_projectile(self.targeted_position - self.global_position)
				
				#if has_node("AudioStreamPlayer2D"):
					#$AudioStreamPlayer2D.play()
					
				await get_tree().create_timer(cooldown).timeout
				in_cooldown = false
