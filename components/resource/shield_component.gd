class_name ShieldComponent
extends Resource


@warning_ignore_start("unused_signal")
signal recharged
signal damaged
signal zero


@export var max_shield: float = 100.0
var shield: float = max_shield

@export_subgroup("Toggles")
@export var can_overshield: bool = false
@export var is_rechargable: bool = true
@export var is_damageable: bool = true
#@export var is_destroyable: bool = true


func recharge(value: float):
	shield = min(max_shield, shield + value)

	
func damage(value: float):
	shield = max(0, shield - value)
