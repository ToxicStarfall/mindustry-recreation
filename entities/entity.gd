class_name Entity
extends Node2D


enum Faction { NONE, PLAYER, ENEMY }

@export var faction: Faction = Faction.NONE
#@export var body: Body

@export_category("Traits")
@export var is_targetable: bool = true


var HitboxComp: HitboxComponent
var HealthComp: HealthComponent
var DefenseComp: DefenseComponent
var ShieldComp: ShieldComponent
#var MovementComp: MovementComponent
var AttackComp: AttackComponent


var statuses: Array

var is_controlled: bool = false  ## Whether or not this entity is currently controlled by the player.
var is_selected: bool = false  ## Whether or not this entity is currently selected by the player.



func _ready() -> void:
	_setup()
	
	
func _setup():
	if has_node("HitboxComponent"):  HitboxComp = $HitboxComponent
	if has_node("HealthComponent"):  HealthComp = $HealthComponent
	#if has_node("MovementComponent"):  MovementComp = $MovementComponent
	if has_node("AttackComponent"):  AttackComp = $AttackComponent
	
	if HitboxComp:
		HitboxComp.hit.connect( _on_hitbox_hit )
	if HealthComp:
		HealthComp.damaged.connect( _on_health_damaged )
		HealthComp.zeroed.connect( _on_health_zeroed )
	#if MovementComp:
		#MovementComp.unit = self


#func _physics_process(delta: float) -> void:
	#if MovementComp:
		#MovementComp._physics_process(delta)


func _on_hitbox_hit():
	if HealthComp:
		HealthComp.damage(1.0)


func _on_health_damaged():
	var tween = create_tween()
	tween.tween_property(self, "modulate:v", modulate.v - modulate.v, 0.15)
	tween.tween_property(self, "modulate:v", modulate.v, 0.1)


func _on_health_zeroed():
	if HealthComp.is_killable:
		self.queue_free()
