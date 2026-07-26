@tool
class_name Projectile
extends Area2D


#enum Faction { NONE, PLAYER, ENEMY }

#@export var faction: Faction = Faction.NONE
@export var faction: Faction
@export var default_size: Vector2 = Vector2(20, 28)

#@export var projectile: Texture2D
#@export var projectile_back: Texture2D
#@export var casing: Texture2D
#@export var falloff_curve: Curve
#@export var spread: float
#@export var casing_speed: float
#@export_range(-180.0, 180.0) var casing_angular_speed: float = -30.0

var lifetime: float = 1.0  ## Projectile lifeitme in seconds.
var speed: float = 10.0  ## Projectile speed in tiles/second.
var direction: Vector2

var damage_comp: DamageComponent

var spawner_entity: Entity



func _init() -> void:
	if !Engine.is_editor_hint():
		faction = Factions.NONE
	pass
	

func _ready() -> void:
	if !is_inside_tree() or !Engine.is_editor_hint():
		#$VisibleOnScreenNotifier2D.screen_exited.connect( func(): queue_free())
		get_tree().create_timer(lifetime).timeout.connect( _on_lifetime_timeout )


func _physics_process(_delta: float) -> void:
	self.position += direction * speed


func collided():
	# Do things after having collided with an object
	self.queue_free()
