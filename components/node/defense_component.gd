@icon("res://assets/icons/components/defense_component.svg")
class_name DefenseComponent
extends Node


@warning_ignore_start("unused_signal")
signal damage_blocked  ## Emitted when damage is processed and partially blocked.
signal damage_fully_blocked  ## Emitted when damage is processed and fully blocked.


@export var defense: float = 0.0
#@export var defense_percent: float = 0.0

@export_group("Toggles")
@export var can_block_damage: bool = true
@export var can_block_all_damage: bool = true


## Applies defence damage reduction to applied damage comps.
func process_damage(damage_comp: DamageComponent):
	if can_block_damage:
		damage_comp.damage -= defense

	return damage_comp
