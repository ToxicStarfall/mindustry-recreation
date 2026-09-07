extends Node2D


var block_debris = []
var unit_debris = []
var max_debris = 40
var max_debris_time = 120

# Block and unit placement
var valid_placement: bool = true
var entity_placer: bool = false
var entity_placer_sprite: Texture2D
var block_placer: bool = false
var block_placer_base_sprite: Texture2D



func _ready() -> void:
	z_index = 1
	pass


func _process(_delta: float) -> void:
	queue_redraw()


func _physics_process(delta: float) -> void:
	for debri in block_debris:
		debri.time -= delta
		#if debri.time <= (0.2 * max_debris_time):
		if debri.time <= 0:
			#block_debri.
			block_debris.erase(debri)


func _draw() -> void:
	_draw_entity_placer()
	_draw_entity_selector()
	_draw_entity_controller()
	_draw_debris()
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
			var block_size: Vector2 = entity_placer_sprite.get_size()
			var mouse_pos: Vector2 = get_global_mouse_position()
			var tile_coords: Vector2i = ((mouse_pos - (block_size/2)) / Game.TILE_SIZE).round()
			var tile_pos: Vector2i = tile_coords * Game.TILE_SIZE
			
			if block_placer_base_sprite:  # Draws base for turrets
				draw_texture(block_placer_base_sprite, tile_pos, Color(1, 1, 1, 0.8))
			draw_texture(entity_placer_sprite, tile_pos, Color(1, 1, 1, 0.8))
			
			# Draw with red overlay sprite if invalid placement position
			if !valid_placement:
				draw_rect( Rect2(tile_pos, block_size), Color(Color.RED, 0.2) )

		# Draw unit placment hint
		else:
			var placer_hint_position =  get_global_mouse_position() - (entity_placer_sprite.get_size() / 2)
			draw_texture(entity_placer_sprite, placer_hint_position, Color(1, 1, 1, 0.8))
			
			# Draw with red overlay sprite if invalid placement position
			if !valid_placement:
				draw_texture(entity_placer_sprite, placer_hint_position, Color(1.0, 0.5, 0.5, 0.6))
			

func _draw_debris():
	var debri_positions = []
	for debri in block_debris:
		if debri_positions.has(debri.position):
			block_debris[ debri_positions.find(debri.position) ].time = max_debris_time  # reset existing debri time
			block_debris.erase(debri)  # erase the duplicate debri
			continue
		else:
			debri_positions.append(debri.position)
		
		var scaler = debri.time / max_debris_time
		var alpha = min(scaler, 0.1) / 0.1  # Scale alpha from 0-1 only while debris lifetime ratio < 0.1
		draw_texture(debri.sprite, debri.position, Color(Color.BLACK, alpha))
		draw_circle(debri.position, 8, Color.RED)  # Position debug hint at top-left.  NOTE - 1x1 block incorrectly offset by -1 tile (for some reason)
	for debri in unit_debris:
		#draw_texture(debri.sprite, debri.position)
		pass


func add_block_debris(debris_position: Vector2i, size: Vector2i):
	# TODO - Add dynamic debri sprite variation handling
	var variation = randi_range(0,0)  # Lock debri variation to first ver.
	if ResourceLoader.exists("res://assets/sprites/rubble/rubble-%s-%s.png" % [size.x, variation] ):
		var texture = ResourceLoader.load("res://assets/sprites/rubble/rubble-%s-%s.png" % [size.x, variation] )
		block_debris.append( { "position": debris_position, "sprite": texture, "time": max_debris_time } )
	#else:
		#push_warning("[Drawer] Add block debris failed")
		#push_warning("res://assets/sprites/rubble/rubble-%s-%s.png" % [size.x, variation])


func add_unit_debris(_debris_position: Vector2, _size: Vector2):
	#var texture = load("res://assets/sprites/rubble/rubble-%s-%s.png" % [size.x, randi_range(0,1)] )
	#block_debris.append( { "position": debris_position, "sprite": texture, "time": max_debris_time } )
	pass
		
		
