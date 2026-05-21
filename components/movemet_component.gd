class_name MovementComponent
extends Node


@export var speed: float = 120.0
@export var rot_speed: float = 120.0


@onready var unit: Node2D = get_parent()

var dir: Vector2


#func _unhandled_input(event: InputEvent) -> void:
	#pass


func _physics_process(delta: float) -> void:
	if unit.can_move:
		var x = Input.get_axis("move_left", "move_right")
		var y = Input.get_axis("move_up", "move_down")
		dir = Vector2(x, y)
		
		unit.position += Vector2(0, y * speed * delta).rotated(unit.rotation)
		unit.rotation_degrees += x * rot_speed * delta
		
		unit.get_node("Tracks").material.set_shader_parameter("dir_x", x)
		unit.get_node("Tracks").material.set_shader_parameter("dir_y", y)
		#unit.get_node("Tracks").region_rect.position.y -= (48.0 / 64) * y
