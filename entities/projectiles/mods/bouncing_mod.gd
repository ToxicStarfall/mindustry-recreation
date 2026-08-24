class_name BouncingMod
extends ProjectileMod


@export var bounces_on_block: bool = true
@export var bounces_on_unit: bool = true
#@export var bounce_on_entity: bool = true

@export var max_bounces: float = 1
@export var bounce_chance: float = 1
@export var bounce_damage_multiplier: float = 1.0

var bounces: int = 0


func _on_projectile_collided(projectile):
	if bounces < max_bounces:
		bounces += 1
		# TODO - Get collision info and apply bounce
	else:
		projectile.queue_free()


func _on_projectile_lifetime_ended(_projectile):
	pass
