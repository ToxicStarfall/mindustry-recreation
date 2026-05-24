class_name MovementComponent
extends Resource


enum MovementType {
	NONE, TRACKED, WHEELED, LEGGED, HOVERING, FLYING, FLOATING,
}

@export var movement_type: MovementType = MovementType.NONE:
	set(value):
		movement_type = value
		pass
@export var speed: float = 120.0
@export var rot_speed: float = 120.0

@export_subgroup("Toggles")
@export var can_move: bool = true
@export var is_ai_controllable: bool = true
@export var is_player_controllable: bool = true

var unit: CharacterBody2D
var dir: Vector2


func _init() -> void:
	pass


func _physics_process(delta: float) -> void:
	if can_move: 
		var x = Input.get_axis("move_left", "move_right")
		var y = Input.get_axis("move_up", "move_down")
		dir = Vector2(x, y)
		
		match movement_type:
			MovementType.TRACKED:
				#unit.position += Vector2(0, y * speed * delta).rotated(unit.rotation)
				unit.move_and_collide(Vector2(0, y * speed * delta).rotated(unit.rotation))
				unit.rotation_degrees += x * rot_speed * delta
				
				unit.get_node("Tracks").material.set_shader_parameter("dir_x", x)
				unit.get_node("Tracks").material.set_shader_parameter("dir_y", y)
				#unit.get_node("Tracks").region_rect.position.y -= (48.0 / 64) * y
				pass
				
			MovementType.WHEELED:
				pass
			_:
				#print("default")
				pass

#func _unhandled_input(_event: InputEvent) -> void:
	#pass
