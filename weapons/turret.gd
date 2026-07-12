class_name Turret
extends RangedWeapon


@export var aim_margin_degrees: float = 1.0  ## 
@export var rotation_speed: float = 90.0  ## Turret rotation speed in degrees.
@export var smart_aiming: bool = true  ## Enables aiming prediction.


func _physics_process(delta: float) -> void:
	super(delta)
	
	if attacking:
		#var mouse_pos = get_global_mouse_position()
		var angle = rotation + get_angle_to(self.target_position)
		rotation = rotate_toward(rotation, angle, delta * deg_to_rad(rotation_speed))  # NOTE: rotate_towards() uses radians.
		
		if !in_cooldown:
			if rotation == angle or abs(rotation - angle) < deg_to_rad(aim_margin_degrees):
				in_cooldown = true
				fire_projectile(self.target_position - self.global_position, get_angle_to(self.target_position))
				#if has_node("AudioStreamPlayer2D"):
					#$AudioStreamPlayer2D.play()
				await get_tree().create_timer(cooldown).timeout
				in_cooldown = false
