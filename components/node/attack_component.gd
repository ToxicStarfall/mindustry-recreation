@icon("res://assets/icons/components/attack_component.svg")
class_name AttackComponent
extends Node


@export_group("Main Attack")
@export var weapons: Array[Weapon]
@export var groups: Array[WeaponGroup]

#@export_category("Special Attack")

@export_category("Toggles")
@export var can_attack: bool = true


var is_attacking: bool = false  ## True when player is overriding attack

var targeted_entity: Entity  ## AI targeted entity
#var targeted_position: Vector2  ## 
#var ordered_target: Entity  ## Player targeted entity (by player given order)



func _physics_process(_delta: float) -> void:
	if is_attacking:
		for weapon in weapons:
			weapon.targeted_position = owner.get_global_mouse_position()
		for weapon_group in groups:
			weapon_group.targeted_position = owner.get_global_mouse_position()
			
	#else:
		#for weapon in weapons:
			#weapon.targeted_entity = targeted_entity
		#for weapon_group in groups:
			#weapon_group.targeted_entity = targeted_entity


func set_attack_status(status: bool):
	is_attacking = status
	
	for weapon in weapons:
		weapon.attacking = is_attacking
	for weapon_group in groups:
		weapon_group.attacking = is_attacking
	
	if is_attacking:
		#for weapon in weapons:
			#weapon.attacking = true
		pass
	#else:
		#for weapon in weapons:
			#weapon.attacking = false

	#for weapon in weapons:
		#weapon.attacking = is_attacking
		#if !owner.is_controlled and !is_attacking:
			#if weapon.targeted_entity != null:
				#weapon.attacking = true  # Enable attacking if there was a previous target once player control stops.


func set_target(target: Entity):
	# NOTE - AI attack is linked to whether there is a target in order to start/stop attacking. 
	if can_attack:
		targeted_entity = target
	
		#print(self)
		if owner and !owner.is_controlled:
			for weapon in weapons:
				weapon.targeted_entity = targeted_entity
				weapon.attacking = (targeted_entity != null)
				#print((targeted_entity != null))
			for weapon_group in groups:
				weapon_group.targeted_entity = targeted_entity
				weapon_group.attacking = (targeted_entity != null)
