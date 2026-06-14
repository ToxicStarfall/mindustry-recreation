class_name Entity
extends Node2D


enum Faction { NONE, PLAYER, ENEMY }

@export var faction: Faction = Faction.NONE
#@export var body: Body

@export_group("Toggles")
@export var is_targetable: bool = true


var HitboxComp: HitboxComponent
var HealthComp: HealthComponent
var DefenseComp: DefenseComponent
var ShieldComp: ShieldComponent
var TargetingComp: TargetingComponent
#var MovementComp: MovementComponent
var AttackComp: AttackComponent

var weapons: Array[Weapon]
var statuses: Array

#var is_controlled: bool = false  ## Whether or not this entity is currently controlled by the player.
#var is_selected: bool = false  ## Whether or not this entity is currently selected by the player.


func _init() -> void:
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )


func _ready() -> void:
	_setup()
	
	
func _setup():
	if has_node("HitboxComponent"):  HitboxComp = $HitboxComponent
	if has_node("HealthComponent"):  HealthComp = $HealthComponent
	if has_node("DefenseComponent"):  DefenseComp = $DefenseComponent
	if has_node("ShieldComponent"):  ShieldComp = $ShieldComponent
	if has_node("TargetingComponent"):  TargetingComp = $TargetingComponent
	
	if HitboxComp:
		HitboxComp.hit.connect( _on_hitbox_hit )
	if HealthComp:
		HealthComp.damaged.connect( _on_health_damaged )
		HealthComp.zeroed.connect( _on_health_zeroed )
		
	if TargetingComp:
		TargetingComp.target_found.connect( _on_target_found )
		TargetingComp.target_changed.connect( _on_target_changed )
		TargetingComp.target_lost.connect( _on_target_lost )


func _on_child_entered_tree(child: Node):
	if child is Weapon:
		weapons.append(child)


func _on_child_exiting_tree(child: Node):
	if child is Weapon:
		weapons.erase(child)


#func _physics_process(delta: float) -> void:
	#if MovementComp:
		#MovementComp._physics_process(delta)


func _on_hitbox_hit(damage_comp: DamageComponent):
	#if DefenseComp:
		#damage_comp = DefenceComp.process_damage(damage_comp)
	if HealthComp:
		HealthComp.damage(damage_comp.base_damage)


func _on_health_damaged():
	var tween = create_tween()
	tween.tween_property(self, "modulate:v", modulate.v - modulate.v, 0.15)
	tween.tween_property(self, "modulate:v", modulate.v, 0.1)


func _on_health_zeroed():
	if HealthComp.is_killable:
		self.queue_free()


func _on_target_found(entity: Entity):
	if entity.is_targetable:
		print("target found: ", entity)
		for weapon in weapons:
			weapon.attacking = true
			#weapon.target_position = entity.global_position
			weapon.target = entity


func _on_target_changed(entity: Entity):
	if entity.is_targetable:
		print("target changed: ", entity)
		for weapon in weapons:
			#weapon.attacking = true
			#weapon.target_position = entity.global_position
			weapon.target = entity
	

func _on_target_lost(entity: Entity):
	print("target lost: ", entity)
	for weapon in weapons:
		weapon.attacking = false
		weapon.target = null
		weapon.target_position = Vector2.ZERO
