@tool
class_name ShapeParticles2D
extends Node2D


enum Shape { CIRCLE, POLYGON }

@export var emitting: bool = false: set = _set_emitting

@export_group("Shape")
@export var shape: Shape = Shape.CIRCLE
@export var radius: float = 1.0
@export var filled: bool = true
@export var width: float = -1.0
@export var offset: Vector2 = Vector2.ZERO

@export_subgroup("Polygon")
@export var sides: int = 3
#@export var sides_length: float = 3


@export_group("Time")
@export var lifetime: float = 1.0
@export var one_shot: bool = false

#@export_group("Initial Velocity")
@export_group("Scale")
@export var scale_amount: Curve2D

@export_group("Color")
@export var color: Color = Color.WHITE
@export var color_ramp: Gradient



var emit_timer = Timer.new()
var draw_delta: float = 0.0



func _ready() -> void:
	add_child(emit_timer)
	emit_timer.wait_time = lifetime
	emit_timer.timeout.connect( _end_emission )
	pass


func _process(delta: float) -> void:
	if emitting:
		draw_delta += delta
		queue_redraw()


func _draw() -> void:
	if emitting:
		match shape:
			Shape.CIRCLE:
				draw_circle( Vector2.ZERO, radius * draw_delta, color, filled, width )

			Shape.POLYGON:
				#var points = []
				#var uvs
				#draw_polygon( Vector2.ZERO, )
				pass


func _set_emitting(value):
	emitting = value
	if emitting:
		emit_timer.start()
	else:
		queue_redraw()  # Redraw to clear drawing


func _end_emission():
	if one_shot:
		emitting = false
	elif emitting:
			emit_timer.start()
	draw_delta = 0.0
