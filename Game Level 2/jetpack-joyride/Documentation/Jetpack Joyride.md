```
Creador: Honikal Coding
Fecha: 03/03/2025
status: Development
```

# Tabla de contenido

- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [2025-03-03](##2025-03-03)

# Introducción

**Jetpack Joyride** es un juego side-scroller infinito, creado en el 2011 (originalmente para móbil). *Solo requiere un botón para controlar al jugador.* El juego es bastante complejo, a pesar de que su premisa suene muy básica. Fue creado por el mismo estudió que creó [Fruit Ninja](https://es.wikipedia.org/wiki/Fruit_Ninja).

El juego controla un personaje con un jetpack, lo importante es: **Al mantener el input, el jugador se eleva (y destruye todo abajo), cuando se suelta el input, el jugador cae, el jugador puede caminar en el suelo**.

| ***Dificultad***         |                      |
| ------------------------ | :------------------: |
| **Complejidad**          |      :luc_star:      |
| **Alcance del Proyecto** | :luc_star::luc_star: |
Éste jugador maneja varios ***power ups y modos de juego especiales***. Sin embargo, la dificultad viene del juego normal, con obstáculos normales, el aplicar *modos de juego* no es necesario en ésta entrega. 
## Metas

* Crear un mapa de juego con un suelo. El mundo avanzará de forma infinita de derecha a izquierda (parallax background).
* Crear un jugador que cae cuando el input se deja de presionar, pero sube si el input se mantiene. 
* Agrega obstáculos que se mueven de derecha a izquierda. Pueden ser más de un solo tipo de obstáculo.
  * Los Obstáculos son ubicados en el mundo usando un script y spawner, el nivel realmente es infinito.
  * Los Obstáculos una vez salen de la pantalla, son eliminados o reciclados.
* El puntaje aumenta con distancia. La meta es superar tu puntaje previo, de modo que el highscore aparezca junto a tu puntaje.

## Metas extra

* Guarda el puntaje entre partidas
* El Jetpack, o el método que tiene para elevarse es una metralleta (o cualquier arma). Se crean balas que se disparan desde éste objeto cuando el input se mantiene.
  * Crea efectos de partículas, para agregar jugo al juego. Prueba por aquí y allá, creando explosiones y chispas una vez se destruyen objetos.

# Desarrollo

## [[2025-03-03]]

El día de hoy fue simple, aproveché durante asistencia para crear la documentación del archivo. El proyecto como tal irá avanzando, pero tuve que tomarme un tiempo desde el último proyecto debido a la Universidad, ya que estuve trabajando en otro proyecto usando Unity, proyecto que intentaré reinterpretar junto al dedicado mío en el nivel 4.