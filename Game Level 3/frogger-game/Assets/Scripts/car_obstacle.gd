class_name Car_Obstacle
extends Obstacle

func _ready() -> void:
	super();  #Llamamos al método de clase padre
	#Configuramos de forma específica los carros

func _change_appeareance(row: int):
	if (animated_sprite_2d):
		animated_sprite_2d.frame = row;

func on_player_collision(player: Player) -> void:
	#Los carros siempre matan al jugador
	player.die();
