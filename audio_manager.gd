extends Node2D


var streams: Array[AudioStream]
var players: Array[AudioStreamPlayer]
var players_2d: Array[AudioStreamPlayer2D]
#var queue

var temp: int = 0
var temp_2d: int = 0



func _ready() -> void:
	Events.audio_requested.connect( _on_audio_requested )
	Events.audio_2d_requested.connect( _on_audio_2d_requested )
	
	for i in 20:
		_create_player_2d()
		#var new_player_2d = AudioStreamPlayer2D.new()
		#new_player_2d.max_polyphony = 5
		#new_player_2d.bus = "Sfx"
		#players_2d.append(new_player_2d)
		#add_child(new_player_2d)


func _on_audio_requested(stream: AudioStream):
	if stream:
		pass


func _on_audio_2d_requested(stream: AudioStream, audio_position: Vector2 = Vector2.ZERO):
	if stream:
		var player = players_2d.pop_front()
		#var temp: bool = false
		if !player:  # Add new temproary player
			player = _create_player_2d()
			temp_2d += 1
		
		player.global_position = audio_position
		player.stream = stream
		player.play()
		await player.finished
		if temp_2d > 1:
			temp_2d -= 1
			player.queue_free()
		else:
			players_2d.append(player)
		pass
		
	
func find(audio_id: String) -> AudioStream:
	if ResourceLoader.exists("res://assets/sounds/" + audio_id + ".ogg"):
		return ResourceLoader.load("res://assets/sounds/" + audio_id + ".ogg")
	return null


func _create_player_2d():
	var new_player_2d = AudioStreamPlayer2D.new()
	new_player_2d.max_polyphony = 5
	new_player_2d.bus = "Sfx"
	players_2d.append(new_player_2d)
	add_child(new_player_2d)
	return new_player_2d
