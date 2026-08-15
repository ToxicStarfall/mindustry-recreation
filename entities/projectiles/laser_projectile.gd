@tool
class_name LaserProjectile
extends Projectile


@export var beam_length: float = 5.0  ## The length of the laser beam in tiles.

@export var stops_on_collision: bool = false


func _ready() -> void:
	if get_tree().edited_scene_root != self:
		get_tree().create_timer(lifetime).timeout.connect( _on_lifetime_timeout )
		#
	#if speed > trail_threshold * Game.TILE_SIZE:
		#$Trail.show()
	
	modulate.a = 0
	$Line2D.width = 0
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 1, 0.25)
	tween.tween_property($Line2D, "width", 12, 0.25)


func _process(_delta: float) -> void:
	if get_tree().edited_scene_root != self:
		# NOTE - Laser projectile is already rotated to correct direction.
		# The Laser beam only needs to extend in default direction (-y dir).

		#$RayCast2D.target_position = self.direction.rotated(-PI/2) * beam_length * Game.TILE_SIZE

		$RayCast2D.target_position = self.direction * beam_length * Game.TILE_SIZE
		$Line2D.set_point_position(0, $RayCast2D.position)
		#$Line2D.set_point_position(1, $RayCast2D.target_position)
		$Line2D.set_point_position(1, Vector2(0,-1) * beam_length * Game.TILE_SIZE)
	pass


func _physics_process(_delta: float) -> void:
	pass


func collided():
	# Do things after having collided with an object
	super()
	pass


func scale_to(_size: Vector2 = self.default_size):
	pass


func _on_lifetime_timeout():
	$RayCast2D.enabled = false
	#for particle in despawn_particles:
		#Events.particle_spawn_requested.emit(particle, self.global_position)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0, 0.25)
	tween.tween_property($Line2D, "width", 0, 0.25)
	await tween.finished
	queue_free()
	pass
