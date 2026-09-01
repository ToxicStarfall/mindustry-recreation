class_name ExplosiveMod
extends ProjectileMod


@export var damage_multiplier: float = 1.0
@export var damage_multiplier_over_range: Curve

@export var explosion_range: float = 1.0  ## Explosion effect area in tiles.
@export var explodes_on_collision: bool = true
@export var explodes_on_lifetime_end: bool = true



func _init() -> void:
	pass


func _spawned(_projectile: Projectile):
	pass


func _despawned(_projectile: Projectile):
	pass


func _collided(_projectile: Projectile):
	pass


# Do things after having collided with an object
func _on_projectile_collided(_projectile):
	pass


func _on_projectile_lifetime_ended(_projectile):
	pass
