class_name AttackComponent
extends Node


@export var turrets: Array[Turret]

@export_category("Toggles")
@export var can_attack: bool = true

var is_attacking: bool = false


@onready var unit: Unit = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		is_attacking = true
		for turret in turrets:
			turret.attacking = true
	if event.is_action_released("attack"):
		is_attacking = false
		for turret in turrets:
			turret.attacking = false
