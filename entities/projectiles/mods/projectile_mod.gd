@abstract 
class_name ProjectileMod
extends Resource


#var projectile: Projectile
@export var callback: ProjectileMod


func _init() -> void:
	pass


func run():
	pass


func _spawned(_projectile: Projectile):
	pass


func _despawned(_projectile: Projectile):
	pass


func _collided(_projectile: Projectile):
	pass


### Runs when the projectile collides with a valid object.
#func _on_projectile_collided(_projectile):
	#pass
#
### Runs when the projectile despawns
#func _on_projectile_lifetime_ended(_projectile):
	#pass
