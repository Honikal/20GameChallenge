class_name Menu
extends Control

@onready var main_title: VBoxContainer = $CenterContainer/MainTitle
@onready var selection: VBoxContainer = $CenterContainer/Selection

@onready var gamemode_opt: OptionButton = $CenterContainer/Selection/GamemodeOpt
@onready var score_box: SpinBox = $CenterContainer/Selection/ScoreBox
@onready var start: Button = $CenterContainer/Selection/Start

#Para modificar el tipo de juego y los datos de score
@onready var data_component: Data_Component = $Data_Component

#Activamos para que se muestren los datos
var selectOptions = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Encendemos y apagamos visualmente los elementos como tal
	main_title.visible = true;
	selection.visible = false;
	
	#Preparamos la señal cuando el jugador presione el botón de jugar
	start.pressed.connect(_begin_game);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("ui_accept") and !selectOptions):
		selectOptions = true;
		main_title.visible = false;
		selection.visible = true;
		
func _begin_game():
	var game_mode: int = gamemode_opt.get_selected_id();
	var score: int = int(score_box.get_line_edit().get_text());
	
	data_component.asign_game_mode(game_mode);
	data_component.asign_max_score(score);
	print("Modo de juego: ", game_mode, " puntuación: ", score);
	
	#Luego cambiamos de escena como tal
	get_tree().change_scene_to_file("res://objects/main.tscn");
	
