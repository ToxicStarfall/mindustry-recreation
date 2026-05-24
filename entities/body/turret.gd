extends Node2D


#@export var ammo: int = 60
#@export var magazine: int = 20
#@export var max_ammo: int = 0  # 
@export var projectile: Projectile
@export var damage_comp: DamageComponent
@export var delay: float = 0.5
@export var cooldown: float = 1.0

@export var rotation_speed: float = 90.0  ## Turret rotation speed in degrees.
@export var smart_aiming: bool = true  ## Enables aiming prediction.

var attacking
var in_cooldown = false


func _physics_process(delta: float) -> void:
	if attacking and !in_cooldown:
		var mouse_pos = get_global_mouse_position()
		var angle = rotation + get_angle_to(mouse_pos)
		rotation = rotate_toward(rotation, angle, delta * deg_to_rad(rotation_speed))  # NOTE: rotate_towards() uses radians.
		
		

func spawn_projectile():
	#var projectile = RigidBody2D.new()
	pass
