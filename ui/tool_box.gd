extends Control



const block_dirs = [
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
var scene: PackedScene

#var placing: bool = false
#var place_sprite: Texture2D



func _ready() -> void:
	# TODO - Add functionality for block selector.
	#%UnitsGrid.item_selected.connect( _on_unit_item_selected )
	%UnitsGrid.multi_selected.connect( _on_unit_item_multi_selected )
	%BlocksGrid.multi_selected.connect( _on_block_item_multi_selected )
	
	%UnitsButton.pressed.connect( func():
		%Units.show()
		%Blocks.hide()
		)
	%BlocksButton.pressed.connect( func():
		%Blocks.show()
		%Units.hide()
		)
	
	_load_sprites()
	_populate_units()
	_populate_blocks()


func _draw() -> void:
	#print("a")
	#if place_sprite:
		#print("b")
		#draw_texture(place_sprite, Vector2.ZERO)
		#draw_circle(Vector2.ZERO, 100, Color.RED)
	pass


func _process(_delta: float) -> void:
	#if placing:
		#queue_redraw()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			#print(selected_block)
			#print(selected_unit)
			
			# TODO - Fix spawning using global mouse pos of UI Canvas Layer
			if scene:
				var mouse_pos = Game.World.get_global_mouse_position()
				if selected_block:
					#Game.World.BlockTileMap
					var block: Unit = scene.instantiate()
					block.position = mouse_pos
					Game.World.add_child(block)
					pass
				elif selected_unit:
					var unit: Unit = scene.instantiate()
					unit.position = mouse_pos
					#print(get_global_mouse_position())
					Game.World.add_child(unit)
					pass
	pass


#func _on_unit_item_selected(index: int):
	#%UnitsGrid.deselect_all()
	#%UnitsGrid.select(index)
		##return
		#
	#for group in sprites.units.serpulo:
		#if sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) ) != null:
			#selected_unit = sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) )
			#break
	##print(selected_unit)
	#if ResourceLoader.exists("res://entities/units/serpulo/" + selected_unit + ".tscn"):
		#var unit_scene = load("res://entities/units/serpulo/" + selected_unit + ".tscn")
		#var unit = unit_scene.instantiate()
		#Game.World.add_child(unit)


func _on_unit_item_multi_selected(index: int, selected: bool):
	#placing = false
	if selected:
		%UnitsGrid.select(index)
		
		# Find the unit associated with the selected unit icon.
		for group in sprites.units.serpulo:
			if sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) ) != null:
				selected_unit = sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) )
				#place_sprite = sprites.units.serpulo[group].get(selected_unit)
				#placing = true
				Drawer.entity_placer_sprite = sprites.units.serpulo[group].get(selected_unit)
				Drawer.entity_placer = true
				break
		# Search for the unit's scene and spawn.
		# TODO - Wait for mouse press after selecting to place
		if ResourceLoader.exists("res://entities/units/serpulo/" + selected_unit + ".tscn"):
			var unit_scene: PackedScene = load("res://entities/units/serpulo/" + selected_unit + ".tscn")
			scene = unit_scene
			#var unit: Unit = unit_scene.instantiate()
			#unit.global_position = get_global_mouse_position()
			#Game.World.add_child(unit)

	else:
		Drawer.entity_placer = false
		%UnitsGrid.deselect_all()
		selected_unit = ""
		scene = null


func _on_block_item_multi_selected(index: int, selected: bool):
	if selected:
		%BlocksGrid.select(index)
	
		# Find the unit associated with the selected unit icon.
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
		if ResourceLoader.exists("res://entities/blocks/" + selected_block + ".tscn"):
			var block_scene: PackedScene = load("res://entities/blocks/" + selected_block + ".tscn")
			scene = block_scene
			#var block: Block = block_scene.instantiate()
			#block.global_position = get_global_mouse_position()
			#Game.World.add_child(block)
	
	else:
		Drawer.entity_placer = false
		Drawer.block_placer = false
		%BlocksGrid.deselect_all()
		selected_block = ""
		scene = null


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
					#print(preview_path)

					# TODO - Unit planet handling. Currently locked to serpulo
					sprites.units.serpulo[group].set(file.get_slice("/", 0), ResourceLoader.load(preview_path) )
					pass
				else:
					#sprites.units[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )
					sprites.units.serpulo[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )
					pass


## Adds units to panel
func _populate_units():
	for group in sprites.units.serpulo:
		for key in sprites.units.serpulo[group]:
			var sprite = sprites.units.serpulo[group][key]
			%UnitsGrid.add_item("", sprite)


## Adds blocks to panel
func _populate_blocks():
	for group in sprites.blocks:
		for key in sprites.blocks[group]:
			var sprite = sprites.blocks[group][key]
			%BlocksGrid.add_item("", sprite)
