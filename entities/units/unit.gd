class_name Unit
extends CharacterBody2D


@export var body: Body
@export var turrets = []

@export_subgroup("Components")
#@export var health: float = 100.0
#@export var defense: float = 0.0
#@export var shield: float = 0.0
@export var HealthComp: HealthComponent
#@export var DefenseComp: DefenseComponent
#@export var ShieldComp: ShieldComponent
@export var MovementComp: MovementComponent

@export_subgroup("Traits")
@export var can_attack: bool = true
@export var is_targetable: bool = true


var statuses: Array

var is_attacking: bool = false
var is_controlled: bool = false  ## Whether or not this unit is currently controlled by the player.
var is_selected: bool = false  ## Whether or not this unit is currently selected by the player.


func _ready() -> void:
	_setup()
	
	
func _setup():
	if HealthComp:
		pass
	if MovementComp:
		MovementComp.unit = self
		
	pass


func _physics_process(delta: float) -> void:
	if MovementComp:
		MovementComp._physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		is_attacking = true
	if event.is_action_released("attack"):
		is_attacking = false
	pass
