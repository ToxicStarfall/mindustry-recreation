extends Node2D


@onready var Camera = get_node("%Camera2D")
var camera_locked: bool = false

var blocks: Array[Block]
var units: Array[Unit]



func _init() -> void:
	Events.projectile_spawned.connect( _on_projectile_spawned )
	
	child_entered_tree.connect( _on_child_entered_tree )
	child_exiting_tree.connect( _on_child_exiting_tree )


func _unhandled_input(event: InputEvent) -> void:
	# NOTE: event.factor is used for variable inputs such as trackpad scroll speed
	var zoom_factor = 0.1
	if Camera.zoom.length() > 1.0:  zoom_factor = 0.2 # Increase zoom factor on mousewheel at close zoom.
	else: zoom_factor = 0.1
	
	# Makes trackpad zoom more smooth and less spotaneous
	if event is InputEventMouseButton and !event.factor == 1:
		zoom_factor = event.factor
		zoom_factor = 0.01

	if event.is_action_pressed("zoom_in"):
		Camera.zoom = (Camera.zoom + (Vector2.ONE * zoom_factor)).minf(2.5)
	if event.is_action_pressed("zoom_out"):
		Camera.zoom = (Camera.zoom - (Vector2.ONE * zoom_factor)).maxf(0.25)

	#if !camera_locked:
		#var pan_x = Input.get_axis("camera_pan_left", "camera_pan_right")
		#var pan_y = Input.get_axis("camera_pan_up", "camera_pan_down")
		#camera_pan_velocity = Vector2(pan_x, pan_y).normalized() * (512 + 256)


#func _physics_process(delta: float) -> void:
	#if !camera_locked:
		#Camera.position += camera_pan_velocity * delta


func _on_camera_lock_changed():
	get_viewport().gui_release_focus()
	camera_locked = !camera_locked
	Camera.limit_enabled = camera_locked
	Camera.drag_horizontal_enabled = camera_locked
	Camera.drag_vertical_enabled = camera_locked

	if camera_locked:
		Camera.position = Vector2.ZERO
		Camera.position_smoothing_speed = 5.0
		#Camera.drag_top_margin = 0.2
		#Camera.drag_bottom_margin = 0.2
		#Camera.drag_left_margin = 0.2
		#Camera.drag_right_margin = 0.2
	else:
		Camera.position_smoothing_speed = 10.0
		#Camera.drag_top_margin = 0.05
		#Camera.drag_bottom_margin = 0.05
		#Camera.drag_left_margin = 0.05
		#Camera.drag_right_margin = 0.05


func _on_child_entered_tree(node: Node):
	if node is Entity:
		node.mouse_entered.connect( _on_mouse_entered_entity.bind(node) )
		node.mouse_exited.connect( _on_mouse_exited_entity.bind(node) )
		if node is Unit:
			units.append(node)
		

func _on_child_exiting_tree(node: Node):
	if node is Entity:
		node.mouse_entered.disconnect( _on_mouse_entered_entity )
		node.mouse_exited.disconnect( _on_mouse_exited_entity )
		if node is Unit:
			units.erase(node)

	
func _on_projectile_spawned(projectile: Projectile):
	add_child( projectile )


func _on_mouse_entered_entity(entity: Entity):
	Game.hovered_entity = entity


func _on_mouse_exited_entity(entity: Entity):
	if Game.hovered_entity != entity:
		pass
	else:
		Game.hovered_entity = null



func get_blocks() -> Array[Block]:
	return blocks


func get_units() -> Array[Unit]:
	return units
