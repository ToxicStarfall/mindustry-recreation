class_name Block
extends Entity


@export var size: Vector2i = Vector2i(1, 1)



func _exit_tree() -> void:
	super()
	# Rebake navigation mesh.
	Game.World.get_node("NavigationRegion2D").bake_navigation_polygon()


func _ready() -> void:
	_setup()
	
	
func _setup():
	super()
	Events.entity_spawned.connect( _on_event_entity_spawned )
	
	add_child(preload("res://entities/block_overlay.tscn").instantiate())
	add_to_group("blocks")


func _on_health_zeroed():
	super()

	var block_position = position - Vector2(size * Game.TILE_SIZE / 2.0).max(Vector2.ONE * Game.TILE_SIZE)
	Drawer.add_block_debris(block_position, size)


func _on_event_entity_spawned(entity: Entity):
	if entity != self:
		if entity is Block:
			if TargetingComp:
				TargetingComp.entities.append(entity)
