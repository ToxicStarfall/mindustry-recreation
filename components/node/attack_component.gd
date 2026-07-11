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

#@onready var unit: Unit = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	#if get_parent().is_controlled:
		#if event.is_action_pressed("attack"):
			#is_attacking = true
		#if event.is_action_released("attack"):
			#is_attacking = false
	
		#if is_attacking:
			#for weapon in weapons:
				#weapon.attacking = true
		#else:
			#for weapon in weapons:
				#weapon.attacking = false #if weapon.target == null else true  # Attacking stays true if there is a target.
	pass


func _physics_process(_delta: float) -> void:
	if is_attacking:
		for weapon in weapons:
			weapon.target_position = get_parent().get_global_mouse_position()


func set_attack_status(status: bool):
	is_attacking = status

	for weapon in weapons:
		weapon.attacking = is_attacking
		#print(weapon.attacking)

		if !owner.is_controlled and !is_attacking:
			if weapon.target != null:
				weapon.attacking = true  # Enable attacking if there was a previous target once player control stops.
		#if is_attacking == false and :
			#if weapon.target != null:
				#weapon.attacking = true
