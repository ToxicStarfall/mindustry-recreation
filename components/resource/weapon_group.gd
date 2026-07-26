class_name WeaponGroup
extends Node2D
#extends Resource

@export var weapons: Array[Weapon] = []
@export var alternating: bool = true
@export var pivoting: bool = true  ## If true, weapons attached
@export var pivot_speed: float = 160.0  ## Pivot speed in degrees/s
#@export var alternate_delay: float = 0.0  ## If 0.0, delay is half of weapon 
#@export var subgroups: Array[WeaponGroup]

@export var aim_margin_degrees: float = 1.0  ## 


var attacking: bool = false: set = attack_status

var targeted_entity: Entity
var targeted_position: Vector2

var last_fired_idx: int = 0


func _ready() -> void:
	#for weapon in weapons:
		#weapon.attack
	pass


func _physics_process(delta: float) -> void:
	if !owner.is_controlled:
	#if owner is Unit and !owner.is_controlled:
	# If only AI controlled, use AI targeted entity as target.
		if targeted_entity:
			targeted_position = targeted_entity.global_position
			#
			#for weapon in weapons:
				#weapon.targeted_position = targeted_position
				#weapon.attacking = true
				#if alternating:
					## Asume all weapons in group are the same when alternating.
					## Make an even delay between weapons to make consecutive shots smooth.
					#await get_tree().create_timer( weapon.cooldown / weapons.size() ).timeout
			#
	#else:
		#
	if attacking:
		if pivoting:
			var angle = rotation + get_angle_to(targeted_position)
			angle += deg_to_rad(90)  # Adjust for built-in 0 degree pointing towards Vector2.RIGHT
			
			# NOTE: rotate_towards() uses radians.
			rotation = rotate_toward(
				rotation,
				angle,
				delta * deg_to_rad(pivot_speed)
			)  
			# TODO Play rotation noise.

			# Allow mounted weapons to fire once bod
			if rotation == angle or abs(rotation - angle) < deg_to_rad(aim_margin_degrees):
				
				# TODO Make consecutive clicks alternate weapons.
				for w_idx in weapons.size():
				#for w_idx in weapons.slice(last_fired_idx, weapons.size()).size():
					#if last_fired_idx == weapons.size() - 1:
						#w_idx = 0
					#else:
						#w_idx += last_fired_idx

					var weapon = weapons.get(w_idx)
					weapon.targeted_position = self.targeted_position
					weapon.attacking = true
					
					#last_fired_idx = w_idx
					#weapons.find(weapon)
					
					if alternating:
						# Asume all weapons in group are the same when alternating.
						# Make an even delay between weapons to make consecutive shots smooth.
						await get_tree().create_timer( weapon.cooldown / weapons.size() ).timeout

	else:
		for weapon in weapons:
			weapon.targeted_position = self.targeted_position
			weapon.attacking = false


func attack_status(status: bool):
	attacking = status
	
	if attacking:
		pass


#func attack():
	#fire_projectile(targeted_position)


#func fire_projectile(dir: Vector2):
	#pass
