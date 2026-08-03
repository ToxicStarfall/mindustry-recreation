class_name MovementComponent
extends Node


enum MovementType {
	NONE, TRACKED, WHEELED, LEGGED, HOVERING, FLYING, FLOATING,
}

@export var movement_type: MovementType = MovementType.NONE  ## Movement method. Determines how 
@export var speed: float = 5.0  ## Movement speed in tiles/s.
@export var rot_speed: float = 120.0  ## Body rotation speed in degrees/s. Affects leg base rot speed for legged units.

#@export_group("Legged")
#@export var base_rotation: float = 210.0  ## Rotation speed of leg base / hip joint.

@export_group("Flying")
@export var drag: float = 10.0  ## Air


@export_category("Toggles")
@export var can_move: bool = true
@export var is_ai_controllable: bool = true
@export var is_player_controllable: bool = true

var unit: Entity
var dir: Vector2

var physics_dalta: float = 0.0
var process_delta: float = 0.0



func _ready() -> void:
	unit = get_parent()
	if !unit is Unit:
		push_warning("Movement component assigned to non-Unit entity.")


func physics_process(delta: float) -> void:
	if can_move: 
		var x = Input.get_axis("move_left", "move_right")
		var y = Input.get_axis("move_up", "move_down")
		dir = Vector2(x, y)
		
		match movement_type:
			MovementType.TRACKED:
				#unit.move_and_collide(Vector2(0, y * speed * delta).rotated(unit.rotation))
				#unit.move_and_collide( Vector2(0, y * (speed * 32) * delta).rotated(unit.rotation))
				unit.velocity = Vector2(0, y * (speed * 32)).rotated(unit.rotation)
				unit.move_and_slide()
				unit.rotation_degrees += x * rot_speed * delta
				pass
				
			MovementType.LEGGED:
				unit.velocity = dir * (speed * Game.TILE_SIZE)
				unit.move_and_slide()
				pass
				
			MovementType.WHEELED:
				pass
				
			MovementType.NONE, _:
				pass


func _process(delta: float) -> void:
	if can_move:
		match movement_type:
			MovementType.TRACKED:
				unit.get_node("%Tracks").material.set_shader_parameter("dir_x", dir.x)
				unit.get_node("%Tracks").material.set_shader_parameter("dir_y", dir.y)
				#unit.get_node("Tracks").region_rect.position.y -= (48.0 / 64) * y
				pass
				
			MovementType.LEGGED:
				# NOTE - Legs scale and move on steps
				var leg_base = unit.get_node("LegBase")  ## Pivot point for legs.
				var legs = leg_base.get_children()
				var leg_count = legs.size()
				var step_size = 10
				var step_speed = 6
				
				if !dir.is_zero_approx():
					process_delta += delta
					
					# Leg animation
					for i in legs.size():
						var leg = legs[i]
						
						# Determines bipedal leg movement direction depending on leg index.
						var a = (1 * -1) ** i
						# Leg y pos follows sine movement pattern
						leg.position.y = 0 + ( sin(process_delta * step_speed) * step_size ) * a
						
						# Interval where sine is increasing / decreasing
						var b = cos(process_delta * step_speed)
						
						## Difference from current leg pos and total distance.
						var diff = abs(leg.position.y - (step_size))
						## Ranges from 1-0 over full step length (fowards and back leg extension)
						var scale = diff / (step_size * 2)
						#print(scale)
						leg.scale.y = 0.5 + (0.5 * scale)  ## Limit scale power to 50%
						
						if b < 0:  # Sine is decreasing:
							pass
						elif b > 0:  # Sine is increasing
							pass
					
					# Leg Base rotation
					leg_base.rotation = rotate_toward(  # NOTE: rotate_towards() uses radians.
						leg_base.rotation, 
						dir.angle() + deg_to_rad(90),  ## Rotate to movement dir axis
						delta * deg_to_rad(rot_speed)
					)
				pass
				
			MovementType.WHEELED:
				pass
			
			MovementType.NONE, _:
				pass
