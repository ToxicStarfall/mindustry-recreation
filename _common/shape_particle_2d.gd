@tool
class_name ShapeParticles2D
extends Node2D


signal finished

enum Shape { CIRCLE, POLYGON }

@export var emitting: bool = false: set = _set_emitting

@export_group("Time")
@export var lifetime: float = 1.0: set = _set_lifetime
@export var one_shot: bool = false


@export_group("Shape")
@export var shape: Shape = Shape.CIRCLE
@export_subgroup("")
@export var filled: bool = true
@export var width: float = -1.0
@export var offset: Vector2 = Vector2.ZERO

@export_subgroup("Circle")
@export var radius: float = 16.0
@export var radius_final: float = 16.0
@export var radius_curve: Curve#: get = _get_radius_curve
@export_subgroup("Polygon")
@export var sides: int = 3
#@export var sides_length: float = 3
#@export var initial_rotation: float = 0.0


#@export_group("Initial Velocity")
@export_group("Scale")
@export var scale_amount: Curve

@export_group("Color")
@export var color: Color = Color.WHITE
@export var color_ramp: Gradient
#@export var color_ramp_lifetime: Gradient


var emit_timer = Timer.new()
var draw_delta: float = 0.0



func _ready() -> void:
	add_child(emit_timer)
	emit_timer.wait_time = lifetime
	emit_timer.timeout.connect( _end_emission )
	if emitting:
		emit_timer.start()
	pass


func _process(delta: float) -> void:
	if emitting:
		draw_delta += delta
		queue_redraw()


func _draw() -> void:
	if emitting:
		match shape:
			Shape.CIRCLE:
				draw_circle (
					Vector2.ZERO + offset,
					#radius * (draw_delta / lifetime),
					#radius + ((radius_final - radius) * (draw_delta / lifetime)),
					radius + (radius_curve.sample(draw_delta / lifetime) if radius_curve
						else (radius_final - radius) * (draw_delta / lifetime)),
					color * color_ramp.sample(draw_delta / lifetime) if color_ramp
						else Color.WHITE,
					filled,
					width
				)
				#print(radius + ((radius_final - radius) * (draw_delta / lifetime)))

			Shape.POLYGON:
				#var points = []
				#var uvs
				#draw_polygon( Vector2.ZERO, )
				pass


# ======== SETTERS ======== #

func _set_emitting(value):
	emitting = value
	if emitting:
		# Stops init error when starting timer before it is ready.
		if emit_timer.is_inside_tree():  
			emit_timer.start()
	else:
		queue_redraw()  # Redraw to clear drawing


func _end_emission():
	if one_shot:
		emitting = false
	elif emitting:
		emit_timer.start()
	draw_delta = 0.0
	finished.emit()


func _set_lifetime(value: float):
	lifetime = value
	emit_timer.wait_time = lifetime


# ======== GETTERS ======== #

#func _get_radius_curve():
	#if radius_curve:
		#return radius_curve
	#else:
		#return 1.0
