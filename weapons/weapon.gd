@icon("res://assets/icons/weapon.svg")
class_name Weapon
extends Node2D


#@export var ammo: int = 60
#@export var magazine: int = 20
#@export var max_ammo: int = 0  # 
#@export var aim_margin_degrees: float = 1.0  ## 
#@export var rotation_speed: float = 90.0  ## Turret rotation speed in degrees.
#@export var smart_aiming: bool = true  ## Enables aiming prediction.

#@export_file(".") var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene: String = "res://scenes/enemies/"
#@export var projectile_scene: PackedScene
@export var damage_comp: DamageComponent
@export var delay: float = 0.5
@export var cooldown: float = 1.0


var attacking: bool = false
var in_cooldown: bool = false

var target: Entity
var target_position: Vector2



func _physics_process(_delta: float) -> void:
	if get_parent() is Unit and !get_parent().is_controlled:
	#else:
		if target:
			target_position = target.global_position
			print(target.global_position)
	#else:
		#target_position = get_global_mouse_position()
		

func _attack():
	pass
