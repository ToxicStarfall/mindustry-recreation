extends CanvasLayer


@onready var ToolBox = %ToolBox


func _ready() -> void:
	Events.entity_controlled.connect( _on_entity_controlled )
	
	%FactionSwitcher/%OptionButton.item_selected.connect( func(idx):
		if Game.controlled_entity: Game.controlled_entity.faction = Factions.factions.keys()[idx]
		pass )
	%PlayButton.pressed.connect( func():
		%StartScreen.hide()
		%Tutorial.show()
		%ToolBox.show()
		$HBoxContainer.show()
		pass )
	
	%StartScreen.show()
	%HelpButton.pressed.connect( func(): %Tutorial.show())
	%ContinueButton.pressed.connect(func(): %Tutorial.hide())
		
	_setup_faction_control_menu()
	pass
	
	
func _process(_delta: float) -> void:
	if Game.controlled_entity:
		%ControlledEntityDisplay/%HealthBar.max_value = Game.controlled_entity.HealthComp.max_health
		%ControlledEntityDisplay/%HealthBar.value = Game.controlled_entity.HealthComp.health
		#%ShieldBar
		#%UnitIcon = ToolBox.sprites
		#%PowerBar
		#%AmmoBar
	pass


func _on_entity_controlled(entity: Entity):
	%FactionSwitcher/%OptionButton.select( Factions.factions.keys().find(entity.faction) )
	pass


func _setup_faction_control_menu():
	#%FactionControlMenu
	#%FactionList
	%FactionList.multi_selected.connect( func(_idx: int, _selected: bool):
		pass )
	%SelectCheckBox.toggled.connect( func(toggled_on: bool):
		if toggled_on:
			%FactionList.deselect_all()
		#else:
			#%FactionList.select()
		pass )
	%AttackButton.pressed.connect( func():
		for i in %FactionList.get_selected_items():
			var faction = %FactionList.get_item_text(i).to_lower()
			#get_tree().call_group(faction, "")
			for node in get_tree().get_nodes_in_group(faction):
				if node.has_node("TargetingComponent"):
					node.TargetingComp.seek(true)
		pass )
	%DefendButton.pressed.connect( func():
		for i in %FactionList.get_selected_items():
			var faction = %FactionList.get_item_text(i).to_lower()
			#get_tree().call_group(faction, "")
			for node in get_tree().get_nodes_in_group(faction):
				if node.has_node("TargetingComponent"):
					node.TargetingComp.seek(false)
		pass )
	#%StopButton
	pass
