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

var target: Entity



func _physics_process(_delta: float) -> void:
	if is_attacking:
		for weapon in weapons:
			weapon.targeted_position = owner.get_global_mouse_position()


func set_attack_status(status: bool):
	is_attacking = status

	for weapon in weapons:
		weapon.attacking = is_attacking
		#print(weapon.attacking)

		if !owner.is_controlled and !is_attacking:
			if weapon.targeted_entity != null:
				weapon.attacking = true  # Enable attacking if there was a previous target once player control stops.
