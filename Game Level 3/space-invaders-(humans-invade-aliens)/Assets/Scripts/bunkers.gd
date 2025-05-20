class_name Bunker
extends StaticBody2D

#Variables
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var game_stats: GameStats;
var currentHealth: int;

var explosion_scene = preload("res://Assets/Scenes/ParticleGenerated.tscn");
const EXPLOSIONSOUND = preload("res://Assets/Sounds/explosion_sound.wav");

#Señales
signal shipDestroyed;

func _ready() -> void:
	#Seteamos la vida del posible bunker
	currentHealth = game_stats.bunkersHealth;
	
	#Conectamos con el caso que el bunker sea destruido o dañado
	shipDestroyed.connect(_damageShip);
	

func _damageShip():
	#Reducimos un poco la vida
	currentHealth-= 1;
	
	#Acá además de eso implementamos algo como para demostrar que se hizo daño, un parpadeo o así
	animation_player.play("hit");
	
	if (currentHealth <= 0):
		#Generamos el efecto de explosión
		var exp_inst : GPUParticles2D = explosion_scene.instantiate();
		get_parent().add_child(exp_inst);
		exp_inst.global_position = global_position;
		exp_inst.emitting = true;
		
		SoundsManager._change_sound(EXPLOSIONSOUND);
		SoundsManager._assignVolume(0.75);
		SoundsManager._play_normal();
		
		#Destruimos el objeto
		queue_free();
		
	
