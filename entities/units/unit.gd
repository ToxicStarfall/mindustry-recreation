class_name Unit
extends Entity



@export var body: Body
	
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
	

func _draw() -> void:
	if TargetingComp:
		TargetingComp.queue_redraw()


func _physics_process(delta: float) -> void:
	if MovementComp:
		#if is_controlled:
			#MovementComp.physics_process(delta)
		#if is_selected:
			#pass
		MovementComp.physics_process(delta)


func _unhandled_input(event: InputEvent) -> void:
	super(event)
	pass
