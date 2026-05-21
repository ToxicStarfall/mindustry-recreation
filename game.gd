extends Node


var current_unit: Unit



func _ready() -> void:
	current_unit = get_tree().root.get_node("Main/Stell")
