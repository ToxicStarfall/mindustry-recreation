class_name TimerMod
extends ProjectileMod


@export var delay: float = 0.0
@export var interval: float = 0.0
@export var mods: Array[ProjectileMod]


func _init() -> void:
	pass


func _spawned(_projectile: Projectile):
	pass


func _despawned(_projectile: Projectile):
	pass


func _collided(_projectile: Projectile):
	pass
