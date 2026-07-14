@abstract
@icon("res://assets/icons/weapon.svg")
class_name Weapon
extends Node2D


@export var damage_comp: DamageComponent
@export var delay: float = 0.5
@export var cooldown: float = 1.0

var attacking: bool = false
var in_cooldown: bool = false

var targeted_entity: Entity
var targeted_position: Vector2



func _physics_process(_delta: float) -> void:
	pass


@abstract func attack()


func target_entity(entity: Entity):
	if entity.is_targetable:
		targeted_entity = entity


func target_position(pos: Vector2):
	targeted_position = pos
