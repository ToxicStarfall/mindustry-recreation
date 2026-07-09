@icon("res://assets/icons/ranged_weapon.svg")
class_name RangedWeapon
extends Weapon

#@export var ammo: int = 60
#@export var magazine: int = 20
#@export var max_ammo: int = 0  # 

#@export_file(".") var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene: String = "res://scenes/enemies/"
@export var projectile_scene: PackedScene

@export_subgroup("Animation")
@export var recoil_dist: float = 10.0  ## Distance of recoil effect in pixels.


#func _physics_process(delta: float) -> void:
	#pass


#func _attack():
	#fire_projectile()


func fire_projectile(dir: Vector2, angle):
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.faction = get_parent().faction
	projectile.spawner_entity = get_parent()
	projectile.damage_comp = damage_comp
	projectile.direction = dir.normalized()
	projectile.position = self.global_position
	projectile.rotation = dir.normalized().rotated(deg_to_rad(90)).angle()
	_animate_recoil()
	
	Events.projectile_spawned.emit( projectile )


func _animate_recoil():
	if has_node("Sprite2D"):
		var tween = create_tween()
		tween.tween_property($Sprite2D, "position:x", position.x - recoil_dist, 0.10 * cooldown).set_trans(Tween.TRANS_SINE)
		tween.tween_property($Sprite2D, "position:x", position.x, 0.80 * cooldown).set_trans(Tween.TRANS_SINE)#.set_ease(Tween.EASE_IN)
