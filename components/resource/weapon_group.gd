class_name WeaponGroup
extends Node

@export var alternating: bool = true
@export var alternate_delay: float = 0.0  ## If 0.0, delay is half of weapon 
@export var weapons: Array[Weapon] = []
@export var subgroups: Array[WeaponGroup]
