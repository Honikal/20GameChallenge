class_name MoveStats;
extends Resource;

#Acá simplemente seteamos variables globales para facilitar datos como movimiento
@export var birdFlySpeed  : int= -200; #Variable de salto
@export var birdFallSpeed : int = 100; #Variable de caída normal
@export var deadBirdSpeed : int = 320; #Variable de caída al morir

@export var obstacleSpeed : int = 125; #Variable de velocidad de obstáculo
@export var increasedFall : float = 0.04; #Variable de porcentaje de incremento por cada cierto tiempo
@export var backgroundSpeed : int = 70; # Variable de velocidad de background
