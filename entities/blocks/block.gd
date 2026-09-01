class_name Block
extends Entity


@export var size: Vector2i = Vector2i(1, 1)


func _init() -> void:
	pass


func _ready() -> void:
	_setup()
	
	
func _setup():
	super()
	#queue_redraw()
	add_child(preload("res://entities/block_overlay.tscn").instantiate())
	
	

#func _draw() -> void:
	#var faction_hint: Texture2D = preload("res://assets/sprites/blocks/extra/block-border.png")
	#if faction_hint:
		#draw_texture( faction_hint, -(size * Game.TILE_SIZE) / 2.0, Factions.get_faction(self.faction).color )
		#print(self)


#func _on_hitbox_hit():
	#if HealthComp:
		#HealthComp.damage(1.0)


#func _on_health_damaged():
	#pass
