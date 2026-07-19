extends Node


@warning_ignore_start("unused_signal")
signal faction_added(faction: Faction)
signal faction_removed(faction: Faction)
signal faction_changed(faction: Faction)


#enum { None, Shard, Crux, Malis }

#static var NONE: Faction = Faction.new("none", "None", Color.LIGHT_GRAY, true)
static var NONE: Faction = Faction.new("none", "None", Color("b6b8c7"), true)
static var SHARD: Faction = Faction.new("shard", "Sharded", Color("fad057"), true)
static var CRUX: Faction = Faction.new("crux", "Crux", Color("f9515e"), true)
static var MALIS: Faction = Faction.new("malis", "Malis", Color("a17de5"), true)


var factions: Dictionary



func _ready() -> void:
	add_faction(NONE)


func add_faction(faction: Faction):
	factions.set(faction.id, faction)
	faction_added.emit(faction)


func remove_faction(faction: Faction):
	factions.erase(faction.id)
	faction_removed.emit(faction)


func get_faction(faction_id: String) -> Faction:
	if factions.has(faction_id):
		return factions.get(faction_id)
	else:
		return null
