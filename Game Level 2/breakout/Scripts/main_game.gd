extends CanvasLayer;

#Exportamos la escena del ladrillo para instanciarla
@export var brick_scene: PackedScene;
@export var ball_scene: PackedScene;

#Flags a usar como tal
var ball_spawned = false;

#Variables de importancia
var boundary_right = ProjectSettings.get_setting("display/window/size/viewport_width");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Primero que todo vamos a generar todos los ladrillos posibles, para ésto llamamos a la función como tal
	_generate_bricks();

func _generate_bricks():
	#Considerando que un ladrillo mide 32x16, tenemos que generar 10 por fila, por ahora generaremos 4 filas (por que solo
	#tenemos 4 colores), y tenemos que instanciar cada uno de los ladrillos a una distancia específica
	
	#Dimensiones del ladrillo
	var brick_width  = 32;
	var brick_height = 16;
	#Espacio en márgenes como tal
	var margin_x: int = 16;
	var margin_y: int = 32;
	var spacing_x: int = 0;
	var spacing_y: int = 2;
	#Número de ladrillos por fila y número de filas
	var bricks_x_row = 10;
	var rows = 4;
	
	#Iteramos como tal por filas
	for row in range(rows):
		#Iteramos por columnas
		for col in range(bricks_x_row):
			#Calculamos la posición del ladrillo
			var x: int = margin_x + (brick_width) * col;
			var y: int = margin_y + (brick_height + spacing_y) * row;
			
			#Instanciamos el ladrillo y asignamos la posición
			var brick : Brick = brick_scene.instantiate();
			brick.global_position = Vector2(x, y);
			brick.frame_color = row; #También usamos el número de fila para determinar el color
			add_child(brick);

func _generate_ball():
	#Asignamos las variables de aparición del objeto
	var x: int = boundary_right / 2;
	var y: int = 256;
	
	var ball : Ball = ball_scene.instantiate();
	ball.global_position = Vector2(x, y);
	add_child(ball);
	ball_spawned = true; #Activamos el hecho que el balón se activó

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Checamos que el jugador presione el botón de lanzamiento del balón, en ese caso, generamos el balón
	if (Input.is_action_just_pressed("ui_accept") && !ball_spawned):
		_generate_ball();
