@tool
extends Node2D



var draw_delta: float = 0.0



func _init() -> void:
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )
	
	
func _on_child_entered_tree(child: Node):	
	if child is RangedWeapon:
		child.test_fired.connect( _on_test_fired )


func _on_child_exiting_tree(child: Node):
	if child is RangedWeapon:
		child.test_fired.disconnect( _on_test_fired )


func _on_test_fired(projectile: Projectile):
	#add_child(projectile, false, Node.INTERNAL_MODE_BACK)
	add_child(projectile)
	#projectile.owner = self
	pass


func _ready() -> void:
	pass
