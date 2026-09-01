class_name MovementComponent
extends Node


enum MovementType {
	NONE, TRACKED, WHEELED, LEGGED, HOVERING, FLYING, FLOATING,
}

@export var movement_type: MovementType = MovementType.NONE  ## Movement method. Determines how 
@export var speed: float = 5.0  ## Movement speed in tiles/s.
@export var rot_speed: float = 120.0  ## Body rotation speed in degrees/s. Affects leg base rot speed for legged units.

@export_group("Legged")
@export var leg_count: int = 2
@export var leg_extend_dist: float
#@export var base_rotation: float = 210.0  ## Rotation speed of leg base / hip joint.

#@export_group("Flying")
@export var accel: float = 1.0  ## Movement acceleration rate
@export var drag: float = 1.0  ## Movement drag rate


@export_category("Toggles")
@export var can_move: bool = true
@export var is_ai_controllable: bool = true
@export var is_player_controllable: bool = true

var is_player_controlled: bool = false

var unit: Entity
var dir: Vector2
var last_dir: Vector2 = Vector2.UP

var target_position: Vector2

var physics_dalta: float = 0.0
var process_delta: float = 0.0



func _ready() -> void:
	unit = get_parent()
	if !unit is Unit:
		push_warning("Movement component assigned to non-Unit entity.")
		
	#if unit.has_node("NavigationAgent2D"):
		#unit.get_node("NavigationAgent2D").target_position = Vector2(-50 * 32, 50 * 32)
		#print(unit)
	match movement_type:
		MovementType.FLOATING, MovementType.WHEELED, MovementType.TRACKED:
			owner.add_child.call_deferred(preload("res://entities/ground_nav_agent_2d.tscn").instantiate())
		MovementType.LEGGED:
			owner.add_child.call_deferred(preload("res://entities/ground_nav_agent_2d.tscn").instantiate())
		MovementType.HOVERING, MovementType.FLYING:
			owner.add_child.call_deferred(preload("res://entities/air_nav_agent_2d.tscn").instantiate())


func physics_process(delta: float) -> void:
	if can_move:
		var x: float = 0.0
		var y: float = 0.0
		
		# Player movement
		if unit.is_controlled:
			x = Input.get_axis("move_left", "move_right")
			y = Input.get_axis("move_up", "move_down")
			dir = Vector2(x, y)
		# AI movement
		else:
			if unit.has_node("NavigationAgent2D"):
				var NavAgent: NavigationAgent2D = unit.get_node("NavigationAgent2D")
				#NavAgent.target_position = owner.get_global_mouse_position()
				#target_position = Vector2.INF
				#if NavAgent.is_target_reached():
					#dir = Vector2.ZERO
					#print("a")
				#elif !NavAgent.is_target_reachable():
					#dir = Vector2.ZERO
					#print("unreachable")
				if NavAgent.is_target_reached() or !NavAgent.is_target_reachable():
					dir = Vector2.ZERO
					#print("a or unreachable")
				# Stop moving when position is within attack range
				elif (NavAgent.get_final_position() - owner.global_position).length() < NavAgent.target_desired_distance:
					#print("b")
					dir = Vector2.ZERO
				else:
					dir = (NavAgent.get_next_path_position() - owner.global_position).normalized()
					#print("c")
		
		if dir != Vector2.ZERO:
			last_dir = dir
		
		match movement_type:
			MovementType.FLOATING:
				# TODO - Test tracked-style movement(below) on boats
				unit.velocity = Vector2(0, y * (speed * 32)).rotated(unit.rotation)
				unit.move_and_slide()
				unit.rotation_degrees += x * rot_speed * delta
				pass
			
			MovementType.TRACKED:
				#if target_position
				unit.velocity = Vector2(0, y * (speed * 32)).rotated(unit.rotation)
				unit.move_and_slide()
				unit.rotation_degrees += x * rot_speed * delta
				pass
				
			MovementType.LEGGED:
				unit.velocity = dir * (speed * Game.TILE_SIZE)
				unit.move_and_slide()
				pass
				
			MovementType.WHEELED:
				# TODO/NOTE - Wheeled movement should be similar to boat movement.
				pass
				
			# TODO - Handle movement velocity using acceleration.
			# TODO - Reduce movement when moving backwards
			MovementType.HOVERING, MovementType.FLYING:
				#unit.velocity = dir * (speed * Game.TILE_SIZE)
				if dir != Vector2.ZERO:
					unit.velocity = dir * (speed * Game.TILE_SIZE)# if dir!=Vector2.ZERO else (unit.velocity - (last_dir * drag * Game.TILE_SIZE)).min(Vector2.ZERO).max(Vector2.ZERO)
					##if dir == Vector2.ZERO: unit.velocity = (unit.velocity - (last_dir * drag * Game.TILE_SIZE)).max(Vector2.ZERO)
				else:
					#var drag_dir: Vector2 = last_dir * min(drag, unit.velocity.length() / speed) * Game.TILE_SIZE
					#unit.velocity = (unit.velocity - drag_dir)
					unit.velocity = unit.velocity.move_toward(Vector2.ZERO, drag * Game.TILE_SIZE)
					#print(unit.velocity.move_toward(Vector2.ZERO, drag * Game.TILE_SIZE * delta))
					#print( unit.velocity, " ", unit.velocity.move_toward(Vector2.ZERO, drag * Game.TILE_SIZE * delta) )
				
				unit.move_and_slide()

				#unit.rotation = last_dir.angle() + (PI / 2)
				if !unit.AttackComp.is_attacking and !dir == Vector2.ZERO:
					unit.rotation = rotate_toward(
						unit.rotation, last_dir.angle() + (PI/2), deg_to_rad(rot_speed) * delta
					)
				#print("r")
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
				var step_size = 10
				var step_speed = 6
				
				if !dir.is_zero_approx():
					process_delta += delta
					
					# Leg animation
					if leg_count == 2:
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
						
					elif leg_count >= 3:
						var leg_base_line: Line2D = leg_base.get_node("LegBaseLine")
						var leg_joint: Sprite2D = leg_base.get_node("LegBaseLine/Joint")
						var leg_line: Line2D = leg_base.get_node("LegBaseLine/Joint/LegLine")
						#var leg_joint_offset: Vector2 = leg_joint.position - leg_base_line.points[1]
						
						#leg_base_line.set_point_position( 1, leg_base_line.points[1] - (dir) )

						var leg_length: float = leg_base_line.points[0].distance_to( leg_base_line.to_local(leg_base_line.current_foot_pos) )
						
						if abs(leg_length) > leg_extend_dist * 1.5:
							#leg_base_line.step(dir, leg_extend_dist * 2, speed * 2)
							
							var rot = (dir.angle() -(PI/2)) - leg_base_line.rotation
							#print(rot)
							leg_base_line.rotate_step(dir, leg_extend_dist * 2, speed * 2, rot)
							pass

						## Leg Base rotation
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
