extends Node2D



func _ready() -> void:
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )
	pass


func _on_child_entered_tree(node: Node):
	pass


func _on_child_exiting_tree(node: Node):
	pass
