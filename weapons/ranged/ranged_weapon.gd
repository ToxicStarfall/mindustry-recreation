@icon("res://assets/icons/ranged_weapon.svg")
class_name RangedWeapon
extends Weapon

#@export var ammo: int = 60
#@export var magazine: int = 20
#@export var max_ammo: int = 0  # 

#@export_file(".") var projectile_scene: PackedScene
#@export_file("*.tscn") var projectile_scene: String = "res://scenes/enemies/"
@export var projectile_scene: PackedScene

#@export var overheats: bool = false
#@export var heat_threshold: float = 100.0
#@export var heat_rate: float = 10.0
#@export var cool_rate: float = 8.0

@export_group("Animation")
@export var recoil_dist: float = 10.0  ## Distance of recoil effect in pixels.

@export_group("Sounds")
@export var fire_sound: AudioStream
@export var reload_sound: AudioStream
#@export var charge: AudioStream
#@export var heatup_sound: AudioStream
#@export var cooldown_sound: AudioStream

#@export_group("Toggles")
#@export var infinite_ammo: bool = false


#func _physics_process(delta: float) -> void:
	#pass


func attack():
	fire_projectile(targeted_position)


func fire_projectile(dir: Vector2):
	var projectile: Projectile = projectile_scene.instantiate()
	projectile.faction = self.owner.faction
	projectile.spawner_entity = self.owner
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
