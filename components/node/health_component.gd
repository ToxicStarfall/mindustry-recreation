@icon("res://assets/icons/components/heart_component.svg")
class_name HealthComponent
extends Node


@warning_ignore_start("unused_signal")
signal healed (overhealed: bool)
signal damaged
signal zeroed


@export var max_health: float = 100.0
var health: float = max_health

@export_category("Toggles")
@export var can_overheal: bool = false
@export var is_healable: bool = true
@export var is_damageable: bool = true
@export var is_killable: bool = true


func _ready() -> void:
	health = max_health
	#print(health, " - ", max_health)
	pass


func heal(value: float):
	health = min(max_health, health + value)
	healed.emit()

	
func damage(value: float):
	health = max(0, health - value)
	damaged.emit()
	
	if health == 0:
		zeroed.emit()
