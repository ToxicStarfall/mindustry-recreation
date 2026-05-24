class_name Projectile
extends RigidBody2D


#@export var projectile: Texture2D
#@export var projectile_back: Texture2D
#@export var casing: Texture2D

@export var projectile_speed: float
@export var projectile_spread: float
@export var casing_speed: float
#@export_range(-180.0, 180.0) var casing_angular_speed: float = -30.0
