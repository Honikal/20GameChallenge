class_name MoveStats;
extends Resource;

#Movimiento de jugador
@export var floatSpeed : int = 130;
@export var floatAcceleration : float = 50.0;
@export var initialBumpAcceleration : int = 25;
@export var gravity : int = 175;

#Movimiento del enemigo
@export var enemyMovement : int = 110;
@export var accelerationFromTime : float = 0.175;
@export var enemyFormationSpeedMult : float = 0.8;
@export var enemyCircleRadius : float = 50.0;
@export var enemyLineSpacing : float = 25.0;

@export var groupSpawnBase : float = 0.1;
@export var groupSpawnMax : float = 0.4;
@export var groupSpawnGrowth : float = 0.0005;
@export var groupSpawnCurrent : float = 0.1;

@export var formationBase: float = 0.1;
@export var formationMax : float = 0.6;
@export var formationGrowth : float = 0.0008;
@export var formationCurrent : float = 0.1;
@export var horizontalBias: float = 0.6;
@export var verticalBias: float = 0.3;
@export var circleBias: float = 0.1;

#Manejamos el movimiento de la partida
@export var speedIncrInterval : int = 100;
@export var spdEnemyIncInterval : int = 300;
@export var speedIncrPercentage : float = 0.15;
@export var spdSpawnReducer : float = 0.05;
@export var minSpawnInterval : float = 2.0; 
