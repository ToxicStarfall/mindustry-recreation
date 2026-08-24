class_name Block
extends Entity



func _init() -> void:
	pass


func _ready() -> void:
	_setup()
	
	
func _setup():
	super()
	


func _draw() -> void:
	var faction_hint: Texture2D = preload("res://assets/sprites/blocks/extra/block-border.png")
	if faction_hint:
		draw_texture( faction_hint, -faction_hint.get_size() / 2, Factions.get_faction(self.faction).color )


func _process(_delta: float) -> void:
	#queue_redraw()
	pass



#func _on_hitbox_hit():
	#if HealthComp:
		#HealthComp.damage(1.0)


#func _on_health_damaged():
	#pass
