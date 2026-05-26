class_name HitboxComponent
extends Area2D


#signal hit(damage, damage_type)
signal hit(damage)


func _init() -> void:
	area_entered.connect( _on_hitbox_area_entered )
	body_entered.connect( _on_hitbox_body_entered )


func _ready() -> void:
	pass


func _on_hitbox_area_entered(area):
	#print(area, " entered hitbox")
	if area is Projectile:
		var projectile: Projectile = area
		if get_parent().faction != projectile.faction or projectile.faction == 0:
			hit.emit()
			projectile.queue_free()


func _on_hitbox_body_entered(body):
	# Physical/Melee/Body damage here.
	#print(body, " entered hitbox")
	pass
