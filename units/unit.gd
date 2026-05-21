class_name Unit
extends Node2D



@export_enum("Floating", "Tracked", "Wheeled", "Legged") var movement_type = "Floating"
@export var body: Body
@export var turrets = []


var controlled: bool  ## whether or not this unit is currently controlled by the player.
var selected: bool  ## whether or not this unit is currently selected by the player.
