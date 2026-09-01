#@tool
@icon("res://assets/icons/components/sight.svg")
## Handles AI Targeting
class_name TargetingComponent
extends Area2D


signal target_found (entity: Entity)
signal target_changed (entity: Entity)
signal target_lost (entity: Entity)

signal seek_state_changed (state: bool)
#signal navigation_


@export var sight_range: float = 10.0
@export var attack_range: float = 10.0

@export_group("Targeting")
@export var targets_closest: bool = true
#@export var targets_strongest: bool = true
#@export var targets_healthiest: bool = true
#@export var targeting_priority: Array


var entities: Array[Entity] = []  ## The entities which are in sight range.
var targets: Array[Entity]  ## The entities which are in attack range and are valid attack targets.
var current_target: Entity  ## The current ai target.

var seeking: bool = false  ## If true, move towards and attack the nearest enemy targets.


func _ready() -> void:
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.radius = sight_range * Game.TILE_SIZE
	#if Engine.is_editor_hint():
		#pass
	#else:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )
		

func _draw() -> void:
	if Debugger.range_visuals_enabled:
		draw_circle(self.position, sight_range * Game.TILE_SIZE, Color(Color.WHITE_SMOKE, .5), false, 4)#, ((sight_range * Game.TILE_SIZE) - (attack_range * Game.TILE_SIZE)))
		#draw_circle(self.position, attack_range * Game.TILE_SIZE, Color(Color.INDIAN_RED, .5), false, 4)


func _physics_process(_delta: float) -> void:
	if seeking:
		if owner.has_node("NavigationAgent2D"):
			var NavAgent: NavigationAgent2D = owner.get_node("NavigationAgent2D")
			var seek_targets = get_tree().get_nodes_in_group("entities").filter( func(entity):
				return entity.faction != owner.faction or (entity.faction == "none" and entity != owner) )
			var closest = get_closest_target(seek_targets)
			
			#if owner.global_position.distance_to(closest.global_position) < NavAgent.target_desired:
			# TODO - only start shooting once in range.
			if closest:
				#if (closest.global_position - self.global_position).length() <= NavAgent.target_desired_distance:
					NavAgent.target_position = closest.global_position
				#if is_in_range(closest):
					if current_target == null:
						current_target = closest
						target_found.emit(current_target)
					elif current_target != null:
						if current_target != closest:
							## Change targets when a different target is closer.
							current_target = closest
							target_changed.emit(current_target)
				#else:
					#print(NavAgent.target_position)
			else:
				#NavAgent.target_position = Vector2.INF
				seek(false)
			#else:
		pass

	else:
		# Add entities in range to list of valid targets.
		for entity in entities:
			var dist = (self.global_position - entity.global_position).length()
			if dist <= attack_range * Game.TILE_SIZE:
				if !targets.has(entity):
					targets.append(entity)
			else:
				targets.erase(entity)
		
		# If there are targets, set the closest one as the current target.
		if !targets.is_empty():
			#var distances = targets.map( func(target): return self.global_position.distance_to(target.global_position))
			#var distances_sorted = distances.duplicate()
			#distances_sorted.sort()
			#var closest = targets.get(distances.find( distances_sorted.get(0) ))
			var closest = get_closest_target(targets)
			#if seeking:
				#if owner.has_node("NavigationAgent2D"):
					#var NavAgent: NavigationAgent2D = owner.get_node("NavigationAgent2D")
					#NavAgent.target_position = closest.global_position
			if closest:
				if current_target == null:
					#print(current_target)
					current_target = closest
					target_found.emit(current_target)
				elif current_target != null:
					if current_target != closest:
						# Change targets when a different target is closer.
						current_target = closest
						target_changed.emit(current_target)


func _on_body_entered(body: Node2D):
	if body is Entity:
		if !body == self.owner:  # Disallow self
			if body.faction != self.owner.faction or body.faction == Factions.NONE.id:  # Disallow same faction
				entities.append(body)
	
	
func _on_body_exited(body: Node2D):
	# NOTE: Deleted entities also send exit signals
	if body is Entity:
		if !body == self.get_parent():
			if entities.has(body):
				entities.erase(body)
				targets.erase(body)
				
				target_lost.emit(current_target)  # NOTE: emitted when valid active or inactive targets exit attack range.
				current_target = null


func attack_target(target: Entity = null):
	if target:
		pass
	else:
		if current_target:
			target_found.emit(current_target)
		else:
			pass
			


func find_target() -> Entity:
	return
	

# Return closest targets from target_list, else null if no targets in list.
func get_closest_target(target_list: Array, idx: int = 0) -> Entity:
	var distances: Array = target_list.map( func(target): return self.global_position.distance_to(target.global_position))
	var distances_sorted = distances.duplicate()
	distances_sorted.sort()
	var closest: Entity = target_list.get(distances.find( distances_sorted.get( idx ) )) if target_list.size() > 0 else null
	return closest

func get_strongest_target():
	pass


func is_in_range(target: Entity) -> bool:
	var NavAgent: NavigationAgent2D = owner.get_node("NavigationAgent2D")
	#if target is Block:
		
	#return owner.global_position.distance_to(target.global_position) < owner.AttackComp.get_weapon_ranges()[0]
	#return (NavAgent.get_next_path_position() - owner.global_position).length() < NavAgent.target_desired_distance
	#return (NavAgent.get_final_position() - owner.global_position).length() < NavAgent.target_desired_distance
	return (target.global_position - owner.global_position).length() < NavAgent.target_desired_distance


func seek(state: bool):
	seeking = state
	var NavAgent: NavigationAgent2D = owner.get_node("NavigationAgent2D")
	if seeking:
		seek_state_changed.emit(state)
		if owner.has_node("NavigationAgent2D"):
			#var seek_targets = get_tree().get_nodes_in_group("entities").filter( func(entity): return entity.faction != owner.faction or entity.faction == "none" )
			#var closest = get_closest_target(seek_targets)
			#NavAgent.target_position = closest.global_position
			
			# Set NavAgent range to edge of attack range based on weapon stats
			if owner.AttackComp:
				var ranges = owner.AttackComp.get_weapon_ranges()
				ranges.sort()
				NavAgent.target_desired_distance = ranges[0] - 32  # -32 to add margin for blocks and nav radius
			#NavAgent.target_desired_distance = attack_range * Game.TILE_SIZE
		pass
	#else:
		#NavAgent.target_position = Vector2.ZERO
	pass
