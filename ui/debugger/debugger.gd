extends Node2D


@onready var DebugPanel = get_tree().root.get_node("Main/UI/MarginContainer")
@onready var DebugText = DebugPanel.get_node("%DebugText")
var disabled
var minimized

var picked_unit: Unit
var moving_unit_enabled: bool = false
var is_moving_unit: bool = false


func _ready() -> void:
	#add_child( preload("res://ui/debugger/debugger.tscn").instrantiate() )
	DebugPanel.show()
	DebugPanel.get_node("%MoveUnitCheckBox").pressed.connect( _moving_unit_toggled )
	
	DebugPanel.get_node("%UncontrolButton").pressed.connect( func():
		Game.controlled_entity = null
		Game.Camera.reparent(Game.World) )



func _draw():
	pass


func _process(_delta: float) -> void:
	DebugText.clear()
	
	DebugText.append_text("[hr height=1 width=100%]")
	DebugText.add_text("Controlled Entity - %s " % [Game.controlled_entity])
	if Game.controlled_entity:
		DebugText.add_text("Player Attack: %s" % [Game.controlled_entity.AttackComp.is_attacking])
		DebugText.add_text("    AI Attack: %s" % [Game.controlled_entity.TargetingComp.current_target != null])
		DebugText.append_text("[br]Health: %s" % [Game.controlled_entity.HealthComp.health])
		
	DebugText.append_text("[hr height=1 width=100%]")
	DebugText.add_text("Hovered Entity - %s " % [Game.hovered_entity])
	if Game.hovered_entity:
		if Game.hovered_entity is Unit:
			DebugText.add_text("Player Attack: %s" % [Game.hovered_entity.AttackComp.is_attacking])
			DebugText.add_text("    AI Attack: %s" % [Game.hovered_entity.TargetingComp.current_target != null])
		DebugText.append_text("[br]Health: %s" % [Game.hovered_entity.HealthComp.health])
		
	DebugText.append_text("[hr height=1 width=100%]")
	pass


func _physics_process(_delta: float) -> void:
	if moving_unit_enabled and picked_unit:
		picked_unit.position = picked_unit.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			if moving_unit_enabled and Game.hovered_entity:
				is_moving_unit = !is_moving_unit
				if is_moving_unit:
					picked_unit = Game.hovered_entity
				else:
					picked_unit = null
		#else:

func _moving_unit_toggled():
	moving_unit_enabled = !moving_unit_enabled
	pass
