extends Node



const TILE_SIZE: int = 32

@onready var World = get_tree().root.get_node("World")
@onready var Camera = World.get_node("%Camera2D")

#var camera_locked: bool = false

var hovered_entity: Entity
var controlled_entity: Entity
var selected_entities: Array[Entity]


func _ready() -> void:
	Events.entity_controlled.connect( _on_entity_controlled )
	Events.entity_selected.connect( _on_entity_selected )


func _unhandled_input(event: InputEvent) -> void:
	## NOTE: event.factor is used for variable inputs such as trackpad scroll speed
	#var zoom_factor = 0.1
	#if Camera.zoom.length() > 1.0:
		#zoom_factor = 0.2
	#else: zoom_factor = 0.1
	#
	## Makes trackpad zoom more smooth and less spotaneous
	#if event is InputEventMouseButton and !event.factor == 1:
		#zoom_factor = event.factor
		#zoom_factor = 0.01
#
	#if event.is_action_pressed("zoom_in"):
		#Camera.zoom = (Camera.zoom + (Vector2.ONE * zoom_factor)).minf(2.5)
	#if event.is_action_pressed("zoom_out"):
		#Camera.zoom = (Camera.zoom - (Vector2.ONE * zoom_factor)).maxf(0.25)
#
	##if !camera_locked:
		##var pan_x = Input.get_axis("camera_pan_left", "camera_pan_right")
		##var pan_y = Input.get_axis("camera_pan_up", "camera_pan_down")
		##camera_pan_velocity = Vector2(pan_x, pan_y).normalized() * (512 + 256)
	#
	if event.is_action_pressed("control"):
		if hovered_entity:
			hovered_entity.is_controlled = true
			Events.entity_controlled.emit(hovered_entity)


#func _physics_process(delta: float) -> void:
	#if !camera_locked:
		#Camera.position += camera_pan_velocity * delta


#func _on_camera_lock_changed():
	#get_viewport().gui_release_focus()
	#camera_locked = !camera_locked
	#Camera.limit_enabled = camera_locked
	#Camera.drag_horizontal_enabled = camera_locked
	#Camera.drag_vertical_enabled = camera_locked
#
	#if camera_locked:
		#Camera.position = Vector2.ZERO
		#Camera.position_smoothing_speed = 5.0
		##Camera.drag_top_margin = 0.2
		##Camera.drag_bottom_margin = 0.2
		##Camera.drag_left_margin = 0.2
		##Camera.drag_right_margin = 0.2
	#else:
		#Camera.position_smoothing_speed = 10.0
		##Camera.drag_top_margin = 0.05
		##Camera.drag_bottom_margin = 0.05
		##Camera.drag_left_margin = 0.05
		##Camera.drag_right_margin = 0.05


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
