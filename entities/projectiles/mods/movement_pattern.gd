class_name MovementPattern
#extends Resource
extends ProjectileMod


@export var initial_speed: float
@export var initial_angle: float
#@export var initial_angle: float

@export_group("Wave Pattern")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var wave_enabled: bool = false
#@export var wave: 
@export var period: float = 1.0
@export var amplitude: float = 1.0

var init_time = Time.get_ticks_msec() / 1000.0


func start():
	pass


func _physics_process():
	#projectile
	pass
