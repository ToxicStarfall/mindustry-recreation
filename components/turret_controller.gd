class_name TurretController
extends Node2D



@onready var unit: Unit = get_parent()


func _physics_process(_delta: float) -> void:
	if unit.can_attack and unit.is_attacking:
		for turret in get_children():
			turret.attacking = true
	else:
		for turret in get_children():
			turret.attacking = false
	pass
