class_name TurretController
extends Node2D



@onready var unit: Unit = get_parent()


func _physics_process(delta: float) -> void:
	if unit.can_attack and unit.is_attacking:
		var turret: Node2D = get_node("Turret")
		var mouse_pos = get_global_mouse_position().rotated( deg_to_rad(90) )
		#var angle = turret.rotation_degrees + rad_to_deg(turret.get_angle_to(mouse_pos))
		var angle = turret.rotation_degrees + rad_to_deg(turret.global_position.angle_to_point(mouse_pos))
		print(angle)
		#turret.rotation_degrees = angle % turret.rotation_speed
		#turret.rotation_degrees = lerp(turret.rotation_degrees, angle, 1 * delta)
		turret.rotation_degrees = move_toward(turret.rotation_degrees, angle, delta * turret.rotation_speed)
		
		#turret.rotation_degrees -= (angle/abs(angle)) * turret.rotation_speed * delta
		#turret.look_at( get_global_mouse_position().rotated( deg_to_rad(90)) )
		
		#if abs(turret.rotation_degrees) > 360.0:
			#turret.rotation_degrees = fmod(turret.rotation_degrees, 360.0)
	pass
