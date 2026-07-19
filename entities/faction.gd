class_name Faction
extends Resource


@export var id: String
@export var name: String
@export var color: Color
@export var hostile: bool = false
@export var relations: Array[FactionRelation]



func _init(new_id: String, new_name: String, new_color: Color, is_hostile: bool, new_relations: Array[FactionRelation] = []) -> void:
	id = new_id
	name = new_name
	color = new_color
	hostile = is_hostile
	relations = new_relations


func add_relation(relation: FactionRelation):
	relations.append(relation)


func get_relation(faction_id: String):
	#if hostile:
		
	pass


## A FactionRelation defines properties of the current relationsihp status
class FactionRelation extends Resource:
	#static var HOSTILE = true
	
	@export var faction_id: String
	@export_range(-100, 100) var relation: int
	@export var mutual: bool = false  ## If true, any changes to relation affect both factions mutually.
	@export var permanant: bool = false  ## If true, the relation status will never change.


	func _init(new_faction_id: StringName, new_relation: int) -> void:
		pass
