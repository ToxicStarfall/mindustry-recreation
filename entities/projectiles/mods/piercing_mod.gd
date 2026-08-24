class_name PiercingMod
extends ProjectileMod


@export var max_piercing: float = 1.0
@export var damage_multiplier: float = 0.75
#@export var pierce_damage_multiplier: float = 1.0
@export var pierces_units: bool = true
@export var pierces_blocks: bool = true
var pierces: float = max_piercing


func _init() -> void:
	pass


func _spawned(_projectile: Projectile):
	pass


func _despawned(_projectile: Projectile):
	pass


func _collided(projectile: Projectile):
	#if (pierces % 1) > 0:
		## Full pierce
		#if pierces >= 1:
			#pierces -= 1
		## Partial pierce
		## TODO - Handle for partial chanced piercing
		#else:
			#pass
	## No pierce
	#else:
		#projectile.queue_free()

	if pierces > 0:
		pierces -= 1
	else:
		projectile.queue_free()
	pass


# Do things after having collided with an object
func _on_projectile_collided(_projectile):
	pass


func _on_projectile_lifetime_ended(_projectile):
	pass
