extends Node2D


var entity_placer: bool = false
var entity_placer_sprite: Texture2D
var block_placer: bool = false
var block_placer_base_sprite: Texture2D



func _ready() -> void:
	#z_index = 2
	pass


func _process(_delta: float) -> void:
	queue_redraw()
	pass


func _draw() -> void:
	_draw_entity_placer()
	_draw_entity_selector()
	_draw_entity_controller()
	#draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.1, 1.1))
	pass


func _draw_entity_selector():
	#draw_colored_polygon()
	pass


func _draw_entity_controller():
	pass


func _draw_entity_placer():
	if entity_placer:
		# Draw block placment hint
		if block_placer:
			#var placer_hint_position =  get_global_mouse_position() - (entity_placer_sprite.get_size() / 2)
			#var BlockTileMap: TileMapLayer = Game.World.get_node("BlockTileMap")
			var block_size: Vector2 = entity_placer_sprite.get_size()
			
			var mouse_pos: Vector2 = get_global_mouse_position()
			var tile_coords: Vector2i = ((mouse_pos - (block_size/2)) / Game.TILE_SIZE).round()
			var tile_pos: Vector2i = tile_coords * Game.TILE_SIZE
			
			# TODO - Verify that the tile coords which the block will occupy do not overlap with existing blocks.
			# Draw with red modulate if invalid placement position
			
			draw_texture(block_placer_base_sprite, tile_pos, Color(1, 1, 1, 0.9))
			draw_texture(entity_placer_sprite, tile_pos, Color(1, 1, 1, 0.9))

		# Draw unit placment hint
		else:
			# TODO - Verify that the placement pos does not overlap with blocks which the unit is unable to move over.
			# Draw with red modulate if invalid placement position
			
			var placer_hint_position =  get_global_mouse_position() - (entity_placer_sprite.get_size() / 2)
			draw_texture(entity_placer_sprite, placer_hint_position, Color(1, 1, 1, 0.9))
			pass
		
		
