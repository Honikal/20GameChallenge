class_name MainMenu
extends Control

@onready var button_score: Button = $MarginContainer/VBoxContainer/VBoxContainer/buttonScore
@onready var button_start: Button = $MarginContainer/VBoxContainer/VBoxContainer/buttonStart
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Acá manejamos las señales para los distintos botones
	button_start.pressed.connect(_go_to_main_game);
	audio_stream_player.finished.connect(transition);
	
func _go_to_main_game():
	audio_stream_player.play();
	
func transition():
	SceneTransition._change_scene("main");
	
func _go_to_score():
	pass
