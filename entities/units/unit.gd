class_name Unit
extends Entity


#enum Faction { NONE, PLAYER, ENEMY }

@export var body: Body
#@export var faction: Faction = Faction.NONE
	
#@export_category("Toggles")
#@export var is_targetable: bool = true


#var HitboxComp: HitboxComponent
#var HealthComp: HealthComponent
#var DefenseComp: DefenseComponent
#var ShieldComp: ShieldComponent
var MovementComp: MovementComponent
#var AttackComp: AttackComponent


#var statuses: Array

#var is_attacking: bool = false
var is_controlled: bool = false  ## Whether or not this unit is currently controlled by the player.
var is_selected: bool = false  ## Whether or not this unit is currently selected by the player.



func _ready() -> void:
	_setup()
	
	
func _setup():
	super()
	if has_node("MovementComponent"):  MovementComp = $MovementComponent
	if has_node("AttackComponent"):  AttackComp = $AttackComponent
	
	if MovementComp:
		MovementComp.unit = self


func _physics_process(delta: float) -> void:
	if MovementComp:
		if is_controlled:
			MovementComp.physics_process(delta)
		if is_selected:
			pass
	#velocity = Vector2.ZERO
	#for index in get_slide_collision_count():
		#var collision: KinematicCollision2D = get_slide_collision(index)
		#if collision.get_collider().name == "Player":
			#velocity = collision.get_normal() * collision.get_collider_velocity().length()
	#move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	#if AttackComp: 
		#if is_controlled:
			#if event.is_action_pressed("attack"):
				#AttackComp.is_attacking = true
			#if event.is_action_released("attack"):
				#AttackComp.is_attacking = false
		#if is_selected:
			#pass
	pass


#func _on_hitbox_hit(damage_comp: DamageComponent):
	#if HealthComp:
		#HealthComp.damage(1.0)


#func _on_health_damaged():
	#var tween = create_tween()
	#tween.tween_property(self, "modulate:v", modulate.v - modulate.v, 0.15)
	#tween.tween_property(self, "modulate:v", modulate.v, 0.1)
