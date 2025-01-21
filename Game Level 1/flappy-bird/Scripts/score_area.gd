class_name ScoreArea
extends Area2D

@onready var score_component = $ScoreComponent as ScoreComponent;
@onready var move_component  = $MoveComponent as Movement;
@onready var score_sound: AudioStreamPlayer = $ScoreSound

@export var move_stats: MoveStats;

#Manejamos las variables para determinar la aparición del obstáculo
@export var marginObstacle = 18;
var boundsLeft = 0;

var game_over : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Llamamos a la señal para checar colisión, en dicho caso entonces actualizamos los datos
	self.area_entered.connect(_update_score);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not game_over):
		move_component.velocity = Vector2(-move_stats.obstacleSpeed, 0);
	
	#Checamos por si la tubería se encuentra fuera de límites
	_clear_obstacle_memory();
	
func _stop_movement():
	game_over = true;
	move_component.velocity = Vector2(0, 0);

func _clear_obstacle_memory():
	if (global_position.x <= boundsLeft - marginObstacle):
		print("Liberamos de memoria el area de puntuacion");
		queue_free();

func _update_score(player: Area2D):
	score_component._update_score();
	score_sound.play();
	
	#Una vez termine de hacer el sonido, acabamos con el objeto
	score_sound.finished.connect(self.queue_free);
