class_name Entity
extends Node2D


#enum Faction { NONE, PLAYER, ENEMY }

#@export var faction: Faction = Faction.NONE
@export var faction: Faction = Factions.NONE
#@export_enum("None", "Shard", "Crux") var faction: String
	#get:
		#return Factions.get_faction(faction)
#@export var body: Body

@export_group("Toggles")
@export var is_targetable: bool = true  ## Whether or not this entity is able to be targeted by other entities.
@export var is_controllable: bool = true  ## Whether or not this entity is able to be controlled by the player.
@export var is_selectable: bool = true  ## Whether or not this entity is able to be selected by the player.

@export var is_controlled: bool = false  ## Whether or not this entity is currently controlled by the player.
@export var is_selected: bool = false  ## Whether or not this entity is currently selected by the player.


var HitboxComp: HitboxComponent
var HealthComp: HealthComponent
var DefenseComp: DefenseComponent
var ShieldComp: ShieldComponent
var TargetingComp: TargetingComponent
#var MovementComp: MovementComponent
var AttackComp: AttackComponent

var weapons: Array[Weapon]
var statuses: Array



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
	if has_node("AttackComponent"):  AttackComp = $AttackComponent
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


func _draw() -> void:
	if is_selected:
		#var rect = get_node("CollisionShape2D").shape.get_rect()
		#rect.size *= 1.1
		#draw_rect(rect, Color.WHITE, false, 4)
		pass


func _process(_delta: float) -> void:
	queue_redraw()


#func _physics_process(delta: float) -> void:
	#if MovementComp:
		#MovementComp._physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if AttackComp: 
		if is_controlled:
			if event.is_action_pressed("attack", false, true):
				#AttackComp.is_attacking = true
				AttackComp.set_attack_status(true)
			if event.is_action_released("attack"):
				#AttackComp.is_attacking = false
				AttackComp.set_attack_status(false)
		if is_selected:
			pass


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


## Runs when there is no current target and a new target is found.
func _on_target_found(entity: Entity):
	if !is_controlled:
		# TODO Fix target found spam when a target is on the edge of attack range.
		print(self, " - target found: ", entity)
		if entity.is_targetable:
			for weapon in weapons:
				weapon.attacking = true
				#weapon.targeted_position = entity.global_position
				weapon.targeted_entity = entity


## Runs when the current target changes to another valid target.
func _on_target_changed(entity: Entity):
	if !is_controlled:
		print(self, " - target changed: ", entity)
		if entity.is_targetable:
			for weapon in weapons:
				#weapon.attacking = true
				#weapon.targeted_position = entity.global_position
				weapon.targeted_entity = entity


## Runs when the current target is lost and there are no other valid targets.
func _on_target_lost(entity: Entity):
	if !is_controlled:
		#if entity.is_targetable:
			print(self, " - target lost: ", entity)
			for weapon in weapons:
				weapon.attacking = false
				weapon.targeted_entity = null
				weapon.targeted_position = Vector2.ZERO
