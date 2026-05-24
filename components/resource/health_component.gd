class_name HealthComponent
extends Resource


@warning_ignore_start("unused_signal")
signal healed
signal damaged
signal zero


@export var max_health: float = 100.0
var health: float = max_health

@export_subgroup("Toggles")
@export var can_overheal: bool = false
@export var is_healable: bool = true
@export var is_damageable: bool = true
@export var is_killable: bool = true


func heal(value: float):
	health = min(max_health, health + value)

	
func damage(value: float):
	health = max(0, health - value)
