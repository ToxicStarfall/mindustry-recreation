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

#var is_attacking: bool = false


func _ready() -> void:
	_setup()
	
	
func _setup():
	super()
	if has_node("MovementComponent"):  MovementComp = $MovementComponent
	#if has_node("AttackComponent"):  AttackComp = $AttackComponent
	
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
	super(event)
	pass
