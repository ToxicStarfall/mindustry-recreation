extends NavigationRegion2D


func _init() -> void:
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )
	

func _on_child_entered_tree(node: Node):
	if node is Block:
		node.mouse_entered.connect( _on_mouse_entered_entity.bind(node) )
		node.mouse_exited.connect( _on_mouse_exited_entity.bind(node) )
		

func _on_child_exiting_tree(node: Node):
	if node is Block:
		node.mouse_entered.disconnect( _on_mouse_entered_entity.bind(node) )
		node.mouse_exited.disconnect( _on_mouse_exited_entity.bind(node) )
		
		
func _on_mouse_entered_entity(entity: Entity):
	Game.hovered_entity = entity


func _on_mouse_exited_entity(entity: Entity):
	if Game.hovered_entity != entity:
		pass
	else:
		Game.hovered_entity = null
