extends Node2D



func _ready() -> void:
	var block: Block = get_parent()
	$Damage.texture.width = block.size.x * Game.TILE_SIZE / $Damage.scale.x
	$Damage.texture.height = block.size.y * Game.TILE_SIZE / $Damage.scale.y
	pass


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	_draw_damage()
	_draw_faction_hint()


func _draw_damage():
	var block: Block = get_parent()
	var health_ratio = block.HealthComp.health / block.HealthComp.max_health
	if health_ratio < 1.0:
		#$Damage.show()
	#print((health_ratio))
		$Damage.texture.color_ramp.set_offset(0, 0.5 + (0.5 * health_ratio) - .005)
		#$Damage.texture.color_ramp.set_offset(0, (1.0 * health_ratio) - .05)
		#$Damage.texture.color_ramp.set_offset(0, (0.3) - .005)
		$Damage.texture.color_ramp.set_offset(1, 0.5 + (0.5 * health_ratio))
		#$Damage.texture.color_ramp.set_offset(1, (1.0 * health_ratio))
	pass


func _draw_faction_hint():
	var faction_hint: Texture2D = preload("res://assets/sprites/blocks/extra/block-border.png")
	if faction_hint:
		#draw_texture( faction_hint, -(get_parent().size * Game.TILE_SIZE) / 2.0, Factions.get_faction(get_parent().faction).color )
		var block: Block = get_parent()
		var pos = -(Vector2(block.size) * Game.TILE_SIZE) / 2.0
		pos += Vector2(0, block.size.y - 1) * Game.TILE_SIZE
		draw_texture( faction_hint, pos, Factions.get_faction(get_parent().faction).color )
	pass
