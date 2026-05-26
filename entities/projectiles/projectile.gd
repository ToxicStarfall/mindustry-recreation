class_name Projectile
extends Area2D


enum Faction { NONE, PLAYER, ENEMY }

@export var faction: Faction = Faction.NONE


#@export var projectile: Texture2D
#@export var projectile_back: Texture2D
#@export var casing: Texture2D
@export var speed: float = 10.0
@export var range: float = 30.0
@export var falloff_curve: Curve
#@export var spread: float
#@export var casing_speed: float
#@export_range(-180.0, 180.0) var casing_angular_speed: float = -30.0

var damage_comp: DamageComponent
var direction: Vector2


func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	self.position += direction * speed	
	pass
