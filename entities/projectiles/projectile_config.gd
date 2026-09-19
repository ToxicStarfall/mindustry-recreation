class_name ProjectileConfig
extends Resource


@export var projectile_scene: PackedScene = preload("res://entities/projectiles/projectile.tscn")
@export var size: Vector2 = Vector2(10, 14)
#@export var count: int = 1
@export var lifetime: float = 1.0
@export var speed: float = 10.0
@export var deviation: float = 0.0
@export var deviation_equalized: bool = false

@export var movement_pattern: MovementPattern
#@export var mods: Array[ProjectileMod]

@export var damage_comp: DamageComponent

#@export var adds_spawner_velocity: bool = false


@export_group("Burst")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var burst_enabled: bool = false
@export var burst_count: float = 1.0
@export var burst_cooldown: float = 1.0
#@export var burst_repeat: int = 1
#@export var burst_repeat_cooldown: float = 1.0
@export var burst_explosiveness: float = 1.0
