class_name HitboxComponent
extends Area2D


#signal hit(damage, damage_type)
signal hit(damage_comp: DamageComponent)


func _init() -> void:
	pass
	


func _ready() -> void:
	area_entered.connect( _on_hitbox_area_entered )
	body_entered.connect( _on_hitbox_body_entered )


# Handles attack damage aoe damage.
func _on_hitbox_area_entered(area):
	#print(area, " entered hitbox.")
	if area is Projectile:
		var projectile: Projectile = area
		# Allow hitting only entities which did not spawn this projectile.
		if projectile.spawner_entity != owner:
			# Allow hitting only entities which belong to differing or NONE faction.
			if owner.faction != projectile.faction or projectile.faction == Factions.NONE:
				hit.emit(projectile.damage_comp)
				projectile.collided()


# Handles body damage.
func _on_hitbox_body_entered(body):
	#print(body, " entered hitbox.")
	pass
