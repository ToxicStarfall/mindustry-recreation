class_name Unit
extends Node2D


#@export var 

@export_enum("Floating", "Tracked", "Wheeled", "Legged") var movement_type = "Floating" 
@export var body: Body
@export var turrets = []


@export_group("Traits")
@export var can_attack: bool = true
@export var can_move: bool = true


var controlled: bool ## whether or not this unit is currently controlled by the player.
var selected: bool = false  ## whether or not this unit is currently selected by the player.

var is_attacking: bool = false



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		is_attacking = true
	if event.is_action_released("attack"):
		is_attacking = false
	pass
