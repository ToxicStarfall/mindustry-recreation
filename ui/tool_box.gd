extends Control



const block_dirs = [
	"res://assets/sprites/blocks/environment/",
	"res://assets/sprites/blocks/walls/",
	"res://assets/sprites/blocks/turrets/",
]
const unit_dirs = [
	"res://assets/sprites/entities/units/ground/",
	"res://assets/sprites/entities/units/air/",
	#"res://assets/sprites/entities/units/water/",
]

var sprites: Dictionary = {
	blocks = {
		environment = {},
		walls = {},
		turrets = {},
		custom = {}
	},
	units = {
		serpulo = { air = {}, ground = {}, water = {} },
		erekir = { air = {}, ground = {}, water = {} },
		custom = { air = {}, ground = {}, water = {} }
	},
}

var selected_block: String
var selected_unit: String
var placement_tester: Area2D
var scene: PackedScene
var instance: Entity

var place_start: Vector2

var selected_faction := "none"
var faction_button_group = ButtonGroup.new()



func _ready() -> void:
	%UnitsGrid.multi_selected.connect( _on_unit_item_multi_selected )
	%BlocksGrid.multi_selected.connect( _on_block_item_multi_selected )
	
	%UnitsButton.pressed.connect( func():
		clear()
		%Units.show()
		%Blocks.hide()
		)
	%BlocksButton.pressed.connect( func():
		clear()
		%Blocks.show()
		%Units.hide()
		)
		
	faction_button_group.pressed.connect( func(button):
		selected_faction = Factions.factions.keys()[button.get_index()] )
	%NoneFactionButton.button_group = faction_button_group
	%ShardFactionButton.button_group = faction_button_group
	%CruxFactionButton.button_group = faction_button_group
	%MalisFactionButton.button_group = faction_button_group
	
	_load_sprites()
	_populate_units()
	_populate_blocks()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_pos = Game.World.get_global_mouse_position()  # Use global mouse position relative to World
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			place_start = mouse_pos
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			if scene:
				if selected_block and Drawer.valid_placement:
					var block: Block = scene.instantiate()
					var block_size: Vector2 = block.size * Game.TILE_SIZE
					var block_offset = (block_size / 2)
					
					#var place_count = mouse_pos.distance_to(place_start)
					# TODO place multiple block in line
					
					var tile_coords: Vector2 = ((mouse_pos - (block_size/2)) / Game.TILE_SIZE).round()
					var tile_pos: Vector2 = (tile_coords * Game.TILE_SIZE) + block_offset
					
					# Block placement handling
					var BlockTileMap: TileMapLayer = Game.World.BlockTileMap
					
					var tiles = []
					for x in block.size.x:
						for y in block.size.y:
							tiles.append( tile_coords + Vector2(x, y) )
					for tile in tiles:
						BlockTileMap.set_cell(tile, 1, Vector2(3,0))  # Set to blank tile
					
					# TODO - Add block to tile map  # NOTE - likely not possible
					#BlockTileMap.set_cell(tile_coords, 3, Vector2.ZERO, 1)
					
					block.position = tile_pos
					#block.get_node("Sprite2D").texture =   # sprite variation
					block.faction = selected_faction
					Game.World.get_node("NavigationRegion2D").add_child(block)
					Game.World.get_node("NavigationRegion2D").bake_navigation_polygon()
					Events.entity_spawned.emit(block)
					Events.audio_2d_requested.emit( AudioManager.find("place"), mouse_pos)
					pass
				# Unit Placmeent handling
				elif selected_unit:
					var unit: Unit = scene.instantiate()
					unit.position = mouse_pos
					unit.faction = selected_faction
					Game.World.add_child(unit)
					Events.entity_spawned.emit(unit)
					pass
		
		if event.button_index == MOUSE_BUTTON_RIGHT and event.is_released():
			# TODO - properly clear placement hints on right click.
			#%BlocksGrid.deselect_all()
			#Drawer.block_placer = false
			if instance:
				clear()
			elif Game.hovered_entity and Game.hovered_entity is Block:
				Game.hovered_entity.queue_free()
				Events.audio_2d_requested.emit( AudioManager.find("break"), mouse_pos)
			pass

	if event is InputEventMouse:
		var mouse_pos = Game.World.get_global_mouse_position()
		if scene:
			if selected_block and instance is Block:
				var block_size: Vector2 = instance.size * Game.TILE_SIZE
				var block_offset = (block_size / 2)
				
				var tile_coords: Vector2 = ((mouse_pos - (block_size/2)) / Game.TILE_SIZE).round()
				var tile_pos: Vector2 = (tile_coords * Game.TILE_SIZE) + block_offset
				
				placement_tester.position = tile_pos
	pass


func _on_unit_item_multi_selected(index: int, selected: bool):
	Drawer.block_placer_base_sprite = null
	Drawer.entity_placer = false
	Drawer.block_placer = false
	%UnitsGrid.deselect_all()
	selected_unit = ""
	scene = null
	if placement_tester: placement_tester.queue_free()
	placement_tester = null
	
	if selected:
		%UnitsGrid.select(index)
		
		# Find the unit associated with the selected unit icon.
		for group in sprites.units.serpulo:
			if sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) ) != null:
				selected_unit = sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) )
				Drawer.entity_placer_sprite = sprites.units.serpulo[group].get(selected_unit)
				Drawer.entity_placer = true
				break
		# Search for the unit's scene and spawn.
		if ResourceLoader.exists("res://entities/units/serpulo/" + selected_unit + ".tscn"):
			var unit_scene: PackedScene = load("res://entities/units/serpulo/" + selected_unit + ".tscn")
			scene = unit_scene
			instance = scene.instantiate()


func _on_block_item_multi_selected(index: int, selected: bool):
	Drawer.block_placer_base_sprite = null
	Drawer.entity_placer = false
	Drawer.block_placer = false
	%BlocksGrid.deselect_all()
	selected_block = ""
	scene = null
	if placement_tester: placement_tester.queue_free()
	placement_tester = null
	
	if selected:
		%BlocksGrid.select(index)
	
		# Find the block associated with the selected block icon.
		for group in sprites.blocks:
			if sprites.blocks[group].find_key( %BlocksGrid.get_item_icon(index) ) != null:
				selected_block = sprites.blocks[group].find_key( %BlocksGrid.get_item_icon(index) )
				
				Drawer.entity_placer = true
				Drawer.entity_placer_sprite = sprites.blocks[group].get(selected_block)
				Drawer.block_placer = true
				
				if group == "turrets":
					var base = str( int(Drawer.entity_placer_sprite.get_size().x / Game.TILE_SIZE) )
					Drawer.block_placer_base_sprite = ResourceLoader.load("res://assets/sprites/blocks/bases/block-" + base + ".png")
					break
		# Search for the block's scene and spawn.
		# TODO - Wait for mouse press after selecting to place
		selected_block = selected_block.get_slice("-preview",0)  # Remove -preview suffix
		if [1,2,3,4,5].has(selected_block.right(1)): selected_block = selected_block.left(selected_block.length() - 1) # Remove variation # suffix
		
		if ResourceLoader.exists("res://entities/blocks/" + selected_block + ".tscn"):
			var block_scene: PackedScene = load("res://entities/blocks/" + selected_block + ".tscn")
			scene = block_scene
			instance = scene.instantiate()
			_block_tester()
		#elif ["pine"].has(selected_block):
			#Bloc


func _block_tester():
	var placement_tester_collision: CollisionShape2D
	if !placement_tester:
		placement_tester = Area2D.new()
		
	if placement_tester:
		# TODO - Clear 
		placement_tester_collision = CollisionShape2D.new()
		placement_tester_collision.shape = RectangleShape2D.new()
		placement_tester_collision.shape.size = Vector2(instance.size) * Game.TILE_SIZE - Vector2(2,2)
		placement_tester.add_child(placement_tester_collision)
		placement_tester.collision_mask = 3

	placement_tester.body_entered.connect( func(body):
		if body is Block or body is Unit:
			if body != instance:
				Drawer.valid_placement = false
		pass )
	placement_tester.body_exited.connect( func(_body):
		Drawer.valid_placement = true
		pass )
	
	Game.World.add_child(placement_tester)


func clear():
	Drawer.entity_placer = false
	Drawer.block_placer = false
	Drawer.block_placer_base_sprite = null
	%UnitsGrid.deselect_all()
	%BlocksGrid.deselect_all()
	selected_unit = ""
	selected_block = ""
	scene = null
	if instance: instance.queue_free()
	instance = null
	if placement_tester: placement_tester.queue_free()
	placement_tester = null
	pass


## Loads block and unit sprites.
func _load_sprites():
	# Load block sprites
	for dir in block_dirs:
		var group = dir.get_slice("/", 5)
		
		for file in ResourceLoader.list_directory(dir):
			if !file.contains("/"):
				if file.contains("-preview") or (file.contains("wall") or !file.contains("-")):
					var preview_path = (dir + file)
					sprites.blocks[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )

	# Load unit sprites
	for dir in unit_dirs:
		var group = dir.split("/")[-2]
		
		for file in ResourceLoader.list_directory(dir):
			if !file.contains("-"):
				var preview_path = (dir + file)  # regular unfoldered unit png
				if file.contains("/"):  # For units in seperate folder.
					preview_path = dir + file + (file.get_slice("/", 0) + ".png")

					# TODO - Unit planet handling. Currently locked to serpulo
					sprites.units.serpulo[group].set(file.get_slice("/", 0), ResourceLoader.load(preview_path) )
					pass
				else:
					sprites.units.serpulo[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )
					pass


## Adds units to panel
func _populate_units():
	var idx = 0
	for group in sprites.units.serpulo:
		for key in sprites.units.serpulo[group]:
			var sprite = sprites.units.serpulo[group][key]
			if ["atrax","crawler","spiroct","alpha","beta","horizon","zenith"].has(key):
				continue
			%UnitsGrid.add_item("", sprite)
			%UnitsGrid.set_item_tooltip(idx, key)
			idx += 1


## Adds blocks to panel
func _populate_blocks():
	var idx = 0
	for group in sprites.blocks:
		for key: String in sprites.blocks[group]:
			if [2, 3, 4, 5].has( int(key.right(1) )):
				continue  # Ignore variations for now.
			if ["scorch"].has(key):
				continue
			var sprite = sprites.blocks[group][key]
			%BlocksGrid.add_item("", sprite)
			%BlocksGrid.set_item_tooltip(idx, key)
			idx += 1
