extends Line2D


#var leg_pos: Vector2

var current_foot_pos: Vector2
var target_foot_pos: Vector2
var step_speed: float
var stepping: bool = false
var rotating: bool = false


@onready var LegJoint = $Joint
@onready var LegLine = $Joint/LegLine
@onready var LegFoot = $Joint/LegLine/Foot


func _ready() -> void:
	current_foot_pos = LegFoot.global_position


func _physics_process(delta: float) -> void:
	if stepping:
		LegFoot.global_position = LegFoot.global_position.move_toward(target_foot_pos, delta * step_speed * Game.TILE_SIZE)
		#current_foot_pos = current_foot_pos.move_toward(target_foot_pos, delta * step_speed * Game.TILE_SIZE)
		pass


func _process(_delta: float) -> void:
	# TODO - Animate step scale
	# TODO - Add step shake
	if stepping:
		
		if LegFoot.global_position.is_equal_approx(target_foot_pos):
			current_foot_pos = target_foot_pos
			stepping = false
			scale /= 1.2
	
	if current_foot_pos:
		self.set_point_position( 1, LegJoint.position )  # Links leg base to joint
		LegLine.set_point_position( 1, LegLine.to_local(LegFoot.global_position) + Vector2(5, 0))  # Links leg line to foot
		
		if !stepping:
			LegFoot.global_position = current_foot_pos
	pass


func step(dir: Vector2, dist: float, speed: float):
	step_speed = speed 
	if stepping:
		# TODO - If another step is requested while stepping, use new targeted step position
		# The leg should immediately place foot down first before stepping to next position.
		pass
	else:
		#target_foot_pos = pos
		target_foot_pos = current_foot_pos + (dir.normalized() * dist)
		#target_foot_pos = ( current_foot_pos + (dir.normalized() * dist) ).rotated(dir.normalized().angle())
		stepping = true
		scale *= 1.2


func rotate_step(dir: Vector2, dist: float, speed: float, rot_amount: float):
	step_speed = speed
	if stepping:
		pass
	else:
		#target_foot_pos = current_foot_pos + (dir.normalized() * dist)
		target_foot_pos = to_global( Vector2.from_angle(self.rotation + rot_amount) )
		stepping = true
		scale *= 1.2
	pass
