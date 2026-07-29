extends Node2D


var streams: Array[AudioStream]
var players: Array[AudioStreamPlayer]
var players_2d: Array[AudioStreamPlayer2D]
#var queue



func _ready() -> void:
	Events.audio_requested.connect( _on_audio_requested )
	Events.audio_2d_requested.connect( _on_audio_2d_requested )
	
	for i in 20:
		var new_player_2d = AudioStreamPlayer2D.new()
		new_player_2d.max_polyphony = 5
		new_player_2d.bus = "Sfx"
		players_2d.append(new_player_2d)
		add_child(new_player_2d)


func _on_audio_requested(stream: AudioStream):
	pass


func _on_audio_2d_requested(stream: AudioStream, audio_position: Vector2 = Vector2.ZERO):
	if stream:
		var player = players_2d.pop_front()
		player.global_position = audio_position
		player.stream = stream
		player.play()
		await player.finished
		players_2d.append(player)
		pass
