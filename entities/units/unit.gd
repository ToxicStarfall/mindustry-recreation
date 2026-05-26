class_name Unit
extends CharacterBody2D


enum Faction { NONE, PLAYER, ENEMY }

@export var body: Body
@export var faction: Faction = Faction.NONE
	
#@export_subgroup("Components")
#@export var HealthComp: HealthComponent
#@export var DefenseComp: DefenseComponent
#@export var ShieldComp: ShieldComponent
#@export var MovementComp: MovementComponent

@export_subgroup("Traits")
@export var is_targetable: bool = true


var HitboxComp: HitboxComponent
var HealthComp: HealthComponent
var DefenseComp: DefenseComponent
var ShieldComp: ShieldComponent
var MovementComp: MovementComponent
var AttackComp: AttackComponent


var statuses: Array

var is_attacking: bool = false
var is_controlled: bool = false  ## Whether or not this unit is currently controlled by the player.
var is_selected: bool = false  ## Whether or not this unit is currently selected by the player.



func _ready() -> void:
	_setup()
	
	
func _setup():
	if has_node("HitboxComponent"):  HitboxComp = $HitboxComponent
	if has_node("HealthComponent"):  HealthComp = $HealthComponent
	if has_node("MovementComponent"):  MovementComp = $MovementComponent
	if has_node("AttackComponent"):  AttackComp = $AttackComponent
	
	if HitboxComp:
		HitboxComp.hit.connect( _on_hitbox_hit )
	if HealthComp:
		HealthComp.damaged.connect( _on_health_damaged )
	if MovementComp:
		MovementComp.unit = self


func _physics_process(delta: float) -> void:
	if MovementComp:
		MovementComp._physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		is_attacking = true
	if event.is_action_released("attack"):
		is_attacking = false


func _on_hitbox_hit():
	if HealthComp:
		HealthComp.damage(1.0)


func _on_health_damaged():
	var tween = create_tween()
	tween.tween_property(self, "modulate:v", modulate.v - modulate.v, 0.15)
	tween.tween_property(self, "modulate:v", modulate.v, 0.1)

#func _
