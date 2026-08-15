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

var selected_block
var selected_unit: String



func _ready() -> void:
	#%UnitsGrid.item_clicked.connect( _on_unit_item_clicked )
	%UnitsGrid.item_selected.connect( _on_unit_item_selected )
	#%BlocksGrid.item_clicked.connect()
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



func _on_unit_item_selected(index: int):
	for group in sprites.units.serpulo:
		if sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) ) != null:
			selected_unit = sprites.units.serpulo[group].find_key( %UnitsGrid.get_item_icon(index) )
			break
	#print(selected_unit)
	var unit = load("res://entities/units/serpulo/" + selected_unit + ".tscn").instantiate()
	Game.World.add_child(unit)


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
					sprites.units.serpulo[group].set(file.get_slice("/", 0), ResourceLoader.load(preview_path) )
					pass
				else:
					#sprites.units[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )
					sprites.units.serpulo[group].set(file.get_slice(".", 0), ResourceLoader.load(preview_path) )
					pass
	pass


func _populate_units():
	#const dir = "res://assets/sprites/entities/units/ground/"
	#var dir_contents = ResourceLoader.list_directory(dir)
	#for file in dir_contents:
		##var scene = ResourceLoader.load( dir + file )
		##var unit: Unit = scene.instantiate()
		##print(unit)
		#
		#var preview_path = ("res://assets/sprites/entities/units/ground/" + file + file.get_slice("/", 0) + ".png")
		#%UnitsGrid.add_item("", ResourceLoader.load(preview_path))
		
	#var dir = DirAccess.open("res://entities/units/serpulo/")
	#if dir:
		#dir.list_dir_begin()
		#var file_name = dir.get_next()
		#while file_name != "":
			#if dir.current_is_dir():
				#print("Found directory: " + file_name)
			#else:
				#print("Found file: " + file_name)
			#file_name = dir.get_next()
	#else:
		#print("An error occurred when trying to access the path.")
	
	for group in sprites.units.serpulo:
		for key in sprites.units.serpulo[group]:
			var sprite = sprites.units.serpulo[group][key]
			%UnitsGrid.add_item("", sprite)


func _populate_blocks():
	for group in sprites.blocks:
		for key in sprites.blocks[group]:
			var sprite = sprites.blocks[group][key]
			%BlocksGrid.add_item("", sprite)
