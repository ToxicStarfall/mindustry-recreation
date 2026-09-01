class_name Entity
extends Node2D


signal faction_changed (new_faction: String)
signal control_changed ()


@export_enum("none", "shard", "crux", "malis") var faction: String : set = _set_faction
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
#var orders: Array  ## An array which represents a queue of orders to enact.



func _init() -> void:
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )


func _on_child_entered_tree(child: Node):
	if child is Weapon:
		if !weapons.has(child):  # prevent duplicate entires
			weapons.append(child)


func _on_child_exiting_tree(child: Node):
	if child is Weapon:
		weapons.erase(child)


func _exit_tree() -> void:
	#if Game.controlled_entity == self:  Game.World.Camera.reparent.call_deferred(Game.World)
	if Game.controlled_entity == self:
		remove_child(Game.World.Camera)
		Game.World.add_child.call_deferred(Game.World.Camera)
	if self is Block:  Game.World.get_node("NavigationRegion2D").bake_navigation_polygon()


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
	
	if !faction: faction = Factions.NONE.id
	add_to_group("entities")
	add_to_group(faction)
	
	if has_node("%Cell"):  %Cell.modulate = Factions.get_faction(faction).color



func _draw() -> void:
	if is_selected:
		#var rect = get_node("CollisionShape2D").shape.get_rect()
		#rect.size *= 1.1
		#draw_rect(rect, Color.WHITE, false, 4)
		pass


func _process(_delta: float) -> void:
	if has_node("%Cell"):
		var time = Time.get_ticks_msec() / 1000.0
		var health_percent = HealthComp.health / HealthComp.max_health
		var freq = clamp(health_percent, 0.125, 0.6)  # Limit flash speed
		var fluct = (sin(time / freq) / 4) + 0.75  # Fluctuates from 0.5 - 1.0
		#%Cell.modulate.a = HealthComp.health / HealthComp.max_health
		#%Cell.modulate.v = HealthComp.health / HealthComp.max_health
		#%Cell.modulate.v = 1.0 * (fluct if health_percent < 1.0 else 1.0)
		%Cell.modulate.v = 1.0 - ((1 - fluct) if health_percent < 1.0 else 0.0)
		#if name == "Stell":
			#print( ((1 - fluct) if health_percent < 1.0 else 0.0) )


#func _physics_process(delta: float) -> void:
	# Handled in unit.gd
	#if MovementComp:
		#MovementComp._physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	if AttackComp: 
		if is_controlled:
			if event.is_action_pressed("attack", false, true):
				AttackComp.set_attack_status(true)
			if event.is_action_released("attack"):
				AttackComp.set_attack_status(false)
		if is_selected:
			pass


func _on_hitbox_hit(damage_comp: DamageComponent):
	if DefenseComp:
		damage_comp = DefenseComp.process_damage(damage_comp)
	if HealthComp:
		HealthComp.damage(damage_comp.base_damage)


func _on_health_damaged():
	var tween = create_tween()
	tween.tween_property(self, "modulate:v", 0.5, 0.1)
	tween.tween_property(self, "modulate:v", 1, 0.075)
	
	#if has_node("%Cell"):
		#%Cell.modulate.a = HealthComp.health / HealthComp.max_health
		#%Cell.modulate.v = HealthComp.health / HealthComp.max_health


func _on_health_zeroed():
	if HealthComp.is_killable:
		Events.audio_2d_requested.emit(AudioManager.find("explosion"), self.position)
		self.queue_free()


## Runs when there is no current target and a new target is found.
func _on_target_found(entity: Entity):
	#if !is_controlled:
		if entity.is_targetable:
			#print(self, " - target found: ", entity)
			AttackComp.set_target(entity)


## Runs when the current target changes to another valid target.
func _on_target_changed(entity: Entity):
	#if !is_controlled:
		if entity.is_targetable:
			#print(self, " - target changed: ", entity)
			AttackComp.set_target(entity)


## Runs when the current target is lost and there are no other valid targets.
func _on_target_lost(_entity: Entity):
	#if !is_controlled:
			#print(self, " - target lost: ", _entity)
			AttackComp.set_target(null)


func _on_control_changed():
	pass


func _set_faction(new_faction: String):
	remove_from_group(faction)
	faction = new_faction
	add_to_group(faction)
	faction_changed.emit(new_faction)
	
	if has_node("%Cell") and is_inside_tree():
		#%Cell.modulate = Factions.get_faction(faction).color
		var _tween = get_tree().create_tween().tween_property(%Cell, "modulate", Factions.get_faction(faction).color, 0.5)


# TODO - 
func _get_movement_speed() -> float:
	var speed: float = 0.0
	if has_node("MovemmentComp"):
		speed = get_node("MovemmentComp").speed
	return speed
