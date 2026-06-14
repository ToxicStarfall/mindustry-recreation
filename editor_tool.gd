@tool
extends Node


func _ready() -> void:
	if Engine.is_editor_hint():
		get_tree().node_added.connect( _on_scene_tree_node_added )
		#get_tree().edited_scene_root.child_entered_tree.connect( _on_scene_tree_node_added )
		pass


func _on_scene_tree_node_added(node: Node):
	if node is HitboxComponent:
		if !node.has_node("CollisionShape2D"):
			var collision_shape = CollisionShape2D.new()
			node.add_child( collision_shape )
			collision_shape.owner = get_tree().edited_scene_root
		
	elif node is TargetingComponent:
		if !node.has_node("CollisionShape2D"):
			node.collision_layer = 0
			node.collision_mask = 7
			node.z_index = -1
			
			var collision_shape = CollisionShape2D.new()
			collision_shape.name = "CollisionShape2D"
			node.add_child( collision_shape )
			collision_shape.owner = get_tree().edited_scene_root
	
	elif node is CollisionShape2D:
		if node.get_parent() is TargetingComponent:
			if node.shape == null:
				var TargetingComp = node.get_parent()
				node.shape = CircleShape2D.new()
				node.shape.radius = TargetingComp.sight_range * Game.TILE_SIZE
	pass
