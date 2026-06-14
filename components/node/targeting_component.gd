#@tool
#@icon("res://assets/icons/components/sight.svg")
class_name TargetingComponent
extends Area2D


signal target_found (entity: Entity)
signal target_changed (entity: Entity)
signal target_lost (entity: Entity)


@export var sight_range: float = 30.0
@export var attack_range: float = 20.0

@export_group("Targeting")
@export var targets_closest: bool = true
@export var targets_weakest: bool = true


var entities: Array[Entity] = []  ## The entities which are in sight range.
var targets: Array[Entity]  ## The entities which are in attack range and are valid attack targets.
var current_target: Entity


func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		body_entered.connect( _on_body_entered )
		body_exited.connect( _on_body_exited )
		

func _draw() -> void:
	draw_circle(self.position, sight_range * Game.TILE_SIZE, Color(Color.WHITE_SMOKE, .5), true)#, ((sight_range * Game.TILE_SIZE) - (attack_range * Game.TILE_SIZE)))
	draw_circle(self.position, attack_range * Game.TILE_SIZE, Color(Color.INDIAN_RED, .5), true, -1)


func _physics_process(_delta: float) -> void:
	for entity in entities:
		var dist = (self.global_position - entity.global_position).length()
		if dist <= attack_range * Game.TILE_SIZE:
			if !targets.has(entity):
				targets.append(entity)
		else:
			targets.erase(entity)
			#target_lost.emit(current_target)
			#current_target = null
	
	if !targets.is_empty():
		var distances = targets.map( func(target): return self.global_position.distance_to(target.global_position))
		var distances_sorted = distances.duplicate()
		distances_sorted.sort()
		
		var closest = targets.get(distances.find( distances_sorted.get(0) ))
		if closest:
			if current_target == null:
				current_target = closest
				target_found.emit(current_target)
			elif current_target != null:
				# Check if not same target
				if current_target != closest:
					# Runs when a different target is closer
					print("AJSD")
					current_target = closest
					target_changed.emit(current_target)
	#else:
		#if current_target:
			


func _on_body_entered(body: Node2D):
	if body is Entity:
		if !body == self.get_parent():
			entities.append(body)
	
	
func _on_body_exited(body: Node2D):
	# NOTE: Delted entities send exit signals
	if body is Entity:
		if !body == self.get_parent():
			entities.erase(body)
			targets.erase(body)
			
			target_lost.emit(current_target)
			current_target = null
	#print(body)
		
	
#func set_sight_range(value):
	#print("sight_range set to ", value)
	##set("sight_range", value)
	#sight_range = value
	#if has_node("CollisionShape2D"):
		#var collision = $CollisionShape2D
		#if collision.shape and collision.shape is CircleShape2D:
			#collision.shape.radius = sight_range * Game.TILE_SIZE
		#else:
			#collision.shape = CircleShape2D.new()
			#collision.shape.radius = sight_range * Game.TILE_SIZE
				
