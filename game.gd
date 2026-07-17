extends Node



const TILE_SIZE: int = 32

@onready var World = get_tree().root.get_node("Main/%World")
@onready var Camera = World.get_node("%Camera2D")

#var camera_locked: bool = false

var hovered_entity: Entity
var controlled_entity: Entity
var selected_entities: Array[Entity]


func _ready() -> void:
	Events.entity_controlled.connect( _on_entity_controlled )
	Events.entity_selected.connect( _on_entity_selected )


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("control"):
		if hovered_entity:
			hovered_entity.is_controlled = true
			Events.entity_controlled.emit(hovered_entity)


func _on_entity_controlled(entity: Entity):
	if controlled_entity:
		controlled_entity.is_controlled = false  # Un-control the previous controlled entity
		controlled_entity.TargetingComp.attack_target()
	controlled_entity = entity
	
	Camera.reparent(controlled_entity)
	Camera.position = Vector2.ZERO


func _on_entity_selected(entity: Entity):
	selected_entities.append(entity)
	pass
	

func add_faction():
	pass


func remove_faction():
	pass
