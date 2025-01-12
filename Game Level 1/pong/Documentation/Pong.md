---

---

```
Creador: Honikal Coding
Fecha: 16/12/2024
status: Development
```
# Tabla de contenidos
- [Introducción](#Introducción)
	- [Metas](##Metas)
	- [Metas extra](##Metas/extra)
- [Desarrollo](#Desarrollo)
	- [2025-01-06](##2025-01-06)
	- [2025-01-08](##2025-01-08)
	- [2025-01-11](##2025-01-11)
	- [2025-01-12](##2025-01-12)
	- [Detalles finales](##Fecha/de/terminación/y/resumen)
# Introducción

Pong fue un juego arcade ampliamente exitoso. Salió en el año 1972, e inició la primera explosión de arcades. El juego parece simple a día de hoy, pero fue diseñado alrededor del hardware. Escencialmente, Pong fue una computadora especializada diseñada para rebotar un balón en medio de 2 raquetas, y mantener una puntuación.

No ocuparemos hacer éste juego mediante partes de computadora, por supuesto! Con una máquina moderna, éste proyecto debería ser sencillo iniciar.

| ***Dificultad***         |                 |
| ------------------------ | :-------------: |
| **Complejidad**          | :luc_star_half: |
| **Alcance del Proyecto** | :luc_star_half: |
## Metas

* Crear una arena con 2 paredes y un divisor
* Agregar una paleta en ambos finales del campo de la arena. Usar inputs del usuario para mover las raquetas arriba y abajo.
* Agregar un balón que se mueve alrededor del campo y rebota en las raquetas y las paredes.
* Detectar cuando el balón sale de la arena. Asignar un punto al jugador que anotó.
* Seguir y mostrar la puntuación de cada jugador.
## Metas extra

* Crear una IA que pueda seguir al balón para poder jugar con un solo jugador.
* Crear un menú y permitir al jugador resetear el juego.
* Agregar sonidos básicos. Reproduce un sonido cada vez que el balón haga colisión con algo, y cada que un jugador gana un punto.
# Desarrollo

Acá entonces, iré detallando una a una, las distintas experiencias que considere importantes a denotar, destacar y considerar, para así en un futuro, de ser necesario volver a checarlas, considerar a releer éste documento, ya que gracias al orden
## [[2025-01-06]]

Fecha de inicio del proyecto, acá empecé con el desarrollo y la creación del proyecto, primero empecé creando los repositorios, preparar documentación principal, y más detalles a tomar en consideración.

Finalmente, iniciamos con la creación del proyecto como tal, y creamos los primeros 3 objetos, el objeto madre de paleta, y el balón base como tal.

Aún sin embargo, requeriremos aplicar el movimiento y los inputs como tal.
## [[2025-01-08]]

En éste día nos encargamos de aplicar el trigger al movimiento, previamente ya tenía la lógica de colisión y demás el balón, ahora lo iniciamos y probamos. 

Al mismo tiempo, empezamos a manejar el sistema de puntuación, colisión para generar puntuación y más. 

Finalmente, terminamos el avance implementando la IA de la paleta que se escoge como IA, haciendo una IA simple que con base a un área, checa que el balón entre a ésta e intenta perseguir su posición como tal.
## [[2025-01-11]]

En éste momento creamos la UI del main menu, así como creamos la UI básica para mostrar puntuación y jugador ganador, en la del main menu nos aseguramos que el usuario pueda seleccionar el modo de juego y la cantidad de puntos para ganar.
## [[2025-01-12]]

Éste día implementamos la lógica de la UI, la implementamos como escena madre, la conectamos a la escena del juego, y acá en el juego manejamos la lógica para determinar aumento de puntuación visual, determinar el ganador de la partida de forma visual, etc. En resumen, determinamos el cómo el jugador puede ganar y lo mostramos visualmente.

Además, observando lo simple que se ve la partida, implementamos un método de aceleración al balón, por cada choque que tenga con una paleta, se incrementa la velocidad del balón.
## Fecha de terminación y resumen

Como tal, concluimos con los detalles de lo aprendido, aprendimos a usar el Vector2D y a usar un Nodo2D como tal, es un Nodo simple, básico, pero bastante práctico y la base de nodos como el KinematicBody. Aprendimos de señales, emisiones y más tipos de escenas, como las de colisiones.

Terminamos el proyecto el día *12 de Enero del 2024, siendo las 3:00 p.m*, hemos aprendido bastante durante el trayecto, al mismo tiempo que usamos de un método para acelerar la curva del balón y creamos una especie de IA algo tonta, pero poco a poco se irá mejorando. 

Después de todo, éste se trata de un miniproyecto para aprender a familiarizarnos con el sistema.