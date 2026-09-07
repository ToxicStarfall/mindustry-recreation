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
	add_child(preload("res://entities/block_overlay.tscn").instantiate())


func _on_health_zeroed():
	super()

	var block_position = position - Vector2(size * Game.TILE_SIZE / 2.0).max(Vector2.ONE * Game.TILE_SIZE)
	Drawer.add_block_debris(block_position, size)
