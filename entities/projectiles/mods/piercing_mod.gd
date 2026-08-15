class_name PiercingMod
extends ProjectileMod


@export var max_pierced: float = 1


func _on_projectile_collided(projecitle):
	# Do things after having collided with an object
	if max_pierced > 0:
		max_pierced -= 1
	else:
		projectile.queue_free()
	pass


func _on_projectile_lifetime_ended(_projecitle):
	pass
