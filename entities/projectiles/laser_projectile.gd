@tool
class_name LaserProjectile
extends Projectile


@export var beam_length: float = 5.0  ## The length of the laser beam in tiles.
@export var beam_width: float = 48.0  ## The width of the laser beam in pixels.
@export var beam_blast_size: Vector2 = Vector2(32, 32)
const beam_overlap: int = 8
# TODO - Add laser end aoe area hitbox
# Currently laser hitbox is limited to the length of the beam.

@export var stops_on_collision: bool = false
#@export var grows: bool = false


func _ready() -> void:
	if get_tree().edited_scene_root != self:
		get_tree().create_timer(lifetime).timeout.connect( _on_lifetime_timeout )
	
		modulate.a = 0
		$Line2D.width = 0
		var tween: Tween = create_tween().set_parallel()
		tween.tween_property(self, "modulate:a", 1, 0.1)
		tween.tween_property($Line2D, "width", 48, 0.1)
		
		$CollisionShape2D.shape.size = Vector2(beam_width / 2, beam_length * Game.TILE_SIZE + 16)
		$CollisionShape2D.position = -Vector2(0, (beam_length * Game.TILE_SIZE + 16) / 2)



func _process(_delta: float) -> void:
	if get_tree().edited_scene_root != self:
		# NOTE - Laser projectile is already rotated to correct direction.
		# The Laser beam only needs to extend in default direction (-y dir).
		
		#$RayCast2D.target_position = Vector2(0, -1) * beam_length * Game.TILE_SIZE
		var target_position = Vector2(0, -1) * beam_length * Game.TILE_SIZE
		
		#$Line2D.set_point_position(0, $RayCast2D.position)
		$Line2D.set_point_position(1, target_position + Vector2(0, 8))
		$LaserEnd.position = target_position


func _physics_process(_delta: float) -> void:
	pass


func collided():
	# Do things after having collided with an object
	#super()
	pass


func scale_to(_size: Vector2 = self.default_size):
	pass


func _on_lifetime_timeout():
	$RayCast2D.enabled = false
	#for particle in despawn_particles:
		#Events.particle_spawn_requested.emit(particle, self.global_position)
	var tween: Tween = create_tween().set_parallel()
	tween.tween_property(self, "modulate:a", 0, 0.15)
	tween.tween_property($Line2D, "width", 0, 0.15)
	await tween.finished
	queue_free()
	pass
