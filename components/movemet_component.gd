class_name MovementComponent
extends Node


@export var speed: float = 120.0
@export var rot_speed: float = 120.0


@onready var entity: Node2D = get_parent()

var dir: Vector2


#func _unhandled_input(event: InputEvent) -> void:
	#pass


func _physics_process(delta: float) -> void:
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_down", "move_up")
	dir = Vector2(x, y)
	
	entity.position += Vector2(0, y * speed * delta).rotated(entity.rotation)
	entity.rotation_degrees += x * rot_speed * delta
	entity.get_node("Tracks").material.set_shader_parameter("dir_x", x)
	entity.get_node("Tracks").material.set_shader_parameter("dir_y", y)
	
