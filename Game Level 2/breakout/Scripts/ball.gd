class_name Ball;
extends Node2D;

#Exportamos el variable para el movimiento
@export var move_stats: Move_Stats;
@onready var move_component: Move_Component = $Move_Component;
@onready var area_2d: Area2D = $Area2D

#Límite como tal para determinar que el balón desaparece una vez llega acá
#se quitarían puntos una vez llega a éste punto
var margin : int = 10;
var score_area = ProjectSettings.get_setting("display/window/size/viewport_height");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Seteamos el movimiento inicial del balón
	move_component.velocity = Vector2(move_stats.actual_ball_speed, move_stats.actual_ball_speed);
	
	#Seteamos como tal la función para checar la posible colisión del balón
	area_2d.area_entered.connect(_bouncing_collision)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Si el balón entra al área donde le quitan puntos al jugador, entonces...
	if (global_position.y >= score_area + margin):
		queue_free();
	
func _wall_bounce():
	#Aplicamos un bounce horizontal, revertimos de forma horizontal la velocidad
	move_component.velocity.x *= -1;

func _bounce(normal: Vector2):
	#Reflejamos la velocidad a través de la normal
	move_component.velocity = move_component.velocity.bounce(normal);

func _bouncing_collision(actor: Area2D):
	var parent = actor.get_parent();
	
	if (parent and (parent is Player or parent is Brick)):
		#Calculamos la colisión normal
		var normal = (global_position - parent.global_position).normalized();
		_bounce(normal);
		print("Rebotamos");
		
		#Si el cuerpo del ladrillo, destruirlo
		if (parent is Brick):
			print("Chocamos con el ladrillo");
			parent.queue_free();
